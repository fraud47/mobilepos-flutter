import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:mobilepos/src/config/app_config.dart';

import '../../features/inventory/domain/entities/inventory_item.dart';
import '../databases/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final listener = InternetConnection();
  yield await listener.hasInternetAccess;

  await for (final status in listener.onStatusChange) {
    yield status == InternetStatus.connected;
  }
});

final offlineSyncServiceProvider = Provider<OfflineSyncService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final service = OfflineSyncService(db);
  service.initNetworkListener();
  return service;
});

class OfflineSyncService {
  OfflineSyncService(this._db);

  final AppDatabase _db;
  final _logger = Logger();

  Dio get _dio => AppConfig.dio;
  bool _isSyncing = false;

  void initNetworkListener() {
    InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        _logger.i('Internet reconnected! Triggering pending sales sync...');
        syncPendingSales();
      }
    });
  }

  /// Cache products locally in SQLite for offline access
  Future<void> cacheProductsLocally(List<InventoryItem> items) async {
    try {
      await _db.transaction(() async {
        for (final item in items) {
          if (item.id == null) continue;
          await _db.into(_db.localProducts).insertOnConflictUpdate(
                LocalProductsCompanion.insert(
                  id: item.id!,
                  name: item.name,
                  stock: Value(item.stock),
                  price: Value(item.price),
                  costPrice: Value(item.costPrice),
                  image: Value(item.image),
                  sku: Value(item.sku),
                  barcode: Value(item.barcode),
                  category: Value(item.category),
                  categoryId: Value(item.categoryId),
                  branchId: Value(item.branchId),
                  enableWholesale: Value(item.enableWholesale),
                ),
              );
        }
      });
      _logger.i('Successfully cached ${items.length} products locally in SQLite');
    } catch (e, stack) {
      _logger.e('Failed to cache products locally', error: e, stackTrace: stack);
    }
  }

  /// Fetch cached products from SQLite when offline
  Future<List<InventoryItem>> getCachedProducts() async {
    try {
      final rows = await _db.select(_db.localProducts).get();
      return rows
          .map(
            (row) => InventoryItem(
              id: row.id,
              name: row.name,
              stock: row.stock,
              price: row.price,
              costPrice: row.costPrice,
              image: row.image ?? '',
              enableWholesale: row.enableWholesale,
              wholesalePrices: const [],
              branchId: row.branchId,
              sku: row.sku,
              category: row.category,
              categoryId: row.categoryId,
              barcode: row.barcode,
            ),
          )
          .toList();
    } catch (e) {
      _logger.e('Failed to load cached products', error: e);
      return [];
    }
  }

  /// Save receipt / sale locally when offline
  Future<String> saveOfflineSale({
    required int? branchId,
    required double totalAmount,
    required double discount,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    final saleId = 'OFFLINE-${DateTime.now().millisecondsSinceEpoch}';
    final itemsJson = jsonEncode(items);

    await _db.into(_db.offlineSales).insert(
          OfflineSalesCompanion.insert(
            id: saleId,
            branchId: Value(branchId),
            totalAmount: totalAmount,
            discount: Value(discount),
            paymentMethod: Value(paymentMethod),
            itemsJson: itemsJson,
            status: const Value('pending'),
            createdAt: DateTime.now(),
          ),
        );

    // Update local stock immediately
    for (final item in items) {
      final productId = item['productId']?.toString() ?? item['id']?.toString();
      final qty = (item['quantity'] is num)
          ? (item['quantity'] as num).toInt()
          : int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

      if (productId != null) {
        final existing = await (_db.select(_db.localProducts)
              ..where((p) => p.id.equals(productId)))
            .getSingleOrNull();

        if (existing != null) {
          final newStock = (existing.stock - qty).clamp(0, 999999);
          await (_db.update(_db.localProducts)..where((p) => p.id.equals(productId)))
              .write(LocalProductsCompanion(stock: Value(newStock)));
        }
      }
    }

    _logger.i('Saved offline sale $saleId locally');
    return saleId;
  }

  /// Upload queued offline sales when back online
  Future<void> syncPendingSales() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pendingSales = await (_db.select(_db.offlineSales)
            ..where((s) => s.status.equals('pending')))
          .get();

      if (pendingSales.isEmpty) {
        _isSyncing = false;
        return;
      }

      _logger.i('Found ${pendingSales.length} pending offline sales. Syncing to server...');

      for (final sale in pendingSales) {
        try {
          final items = jsonDecode(sale.itemsJson) as List<dynamic>;
          final payload = {
            if (sale.branchId != null) 'branchId': sale.branchId,
            'totalAmount': sale.totalAmount,
            'discount': sale.discount,
            'paymentMethod': sale.paymentMethod,
            'items': items,
            'offlineSaleId': sale.id,
            'createdAt': sale.createdAt.toIso8601String(),
          };

          final response = await _dio.post('/receipts', data: payload);

          if (response.statusCode == 200 || response.statusCode == 201) {
            await (_db.update(_db.offlineSales)..where((s) => s.id.equals(sale.id)))
                .write(const OfflineSalesCompanion(status: Value('synced')));
            _logger.i('Successfully synced offline sale ${sale.id}');
          }
        } catch (e) {
          _logger.e('Failed to sync offline sale ${sale.id}', error: e);
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
