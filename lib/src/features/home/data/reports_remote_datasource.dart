import 'package:dio/dio.dart';
import 'package:mobilepos/src/config/app_config.dart';

class SalesSummary {
  final double grandTotal;
  final int invoiceCount;

  const SalesSummary({required this.grandTotal, required this.invoiceCount});

  factory SalesSummary.fromJson(Map<String, dynamic> json) => SalesSummary(
        grandTotal: double.tryParse(json['grandTotal']?.toString() ?? '0') ?? 0,
        invoiceCount: json['invoiceCount'] as int? ?? 0,
      );
}

class SalesByProduct {
  final int productId;
  final String productName;
  final double total;
  final double qty;

  const SalesByProduct({
    required this.productId,
    required this.productName,
    required this.total,
    required this.qty,
  });

  factory SalesByProduct.fromJson(Map<String, dynamic> json) => SalesByProduct(
        productId: json['productId'] as int? ?? 0,
        productName: json['productName']?.toString() ?? '',
        total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
        qty: double.tryParse(json['qty']?.toString() ?? '0') ?? 0,
      );
}

class PurchaseSummary {
  final int receiptCount;
  final double totalLineValue;
  final double totalQty;

  const PurchaseSummary({
    required this.receiptCount,
    required this.totalLineValue,
    required this.totalQty,
  });

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) =>
      PurchaseSummary(
        receiptCount: json['receiptCount'] as int? ?? 0,
        totalLineValue:
            double.tryParse(json['totalLineValue']?.toString() ?? '0') ?? 0,
        totalQty:
            double.tryParse(json['totalQty']?.toString() ?? '0') ?? 0,
      );
}

class ReportsRemoteDataSource {
  ReportsRemoteDataSource._();
  static final instance = ReportsRemoteDataSource._();

  Dio get _dio => AppConfig.dio;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<SalesSummary> getSalesSummary(DateTime from, DateTime to) async {
    final resp = await _dio.get<Map<String, dynamic>>(
      '/api/v1/reports/sales-summary',
      queryParameters: {'from': _fmt(from), 'to': _fmt(to)},
    );
    final data = (resp.data?['data'] as Map<String, dynamic>?) ?? {};
    return SalesSummary.fromJson(data);
  }

  Future<List<SalesByProduct>> getSalesByProduct(
      DateTime from, DateTime to) async {
    final resp = await _dio.get<Map<String, dynamic>>(
      '/api/v1/reports/sales-by-product',
      queryParameters: {'from': _fmt(from), 'to': _fmt(to)},
    );
    final list = (resp.data?['data'] as List<dynamic>?) ?? [];
    return list
        .map((e) => SalesByProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PurchaseSummary> getPurchaseSummary(DateTime from, DateTime to) async {
    final resp = await _dio.get<Map<String, dynamic>>(
      '/api/v1/reports/purchases',
      queryParameters: {'from': _fmt(from), 'to': _fmt(to)},
    );
    final data = (resp.data?['data'] as Map<String, dynamic>?) ?? {};
    return PurchaseSummary.fromJson(data);
  }
}
