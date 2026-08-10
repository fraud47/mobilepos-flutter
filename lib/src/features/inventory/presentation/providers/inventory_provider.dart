import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/entities/product_category.dart';
import 'package:mobilepos/src/features/branches/presentation/providers/branch_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/data_sources/impl/inventory_remote_datasource_impl.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/repositories/inventory_repository_impl.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl(InventoryRemoteDataSourceImpl.instance);
});

final inventoryListProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  final activeBranch = ref.watch(activeBranchProvider);
  final result = await repository.getInventory(branchId: activeBranch?.id);
  return result.fold(
    (failure) => throw failure.message,
    (products) => products,
  );
});

class AddProductNotifier extends StateNotifier<AsyncValue<void>> {
  final InventoryRepository _repository;
  final Ref _ref;

  AddProductNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> createProduct(Map<String, dynamic> payload) async {
    state = const AsyncValue.loading();
    final result = await _repository.createProduct(payload);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (product) {
        state = const AsyncValue.data(null);
        // Refresh the inventory list upon successful creation
        _ref.invalidate(inventoryListProvider);
        _ref.invalidate(homeProductsProvider);
      },
    );
  }

  Future<void> updateProduct(String id, Map<String, dynamic> payload) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateProduct(id, payload);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (product) {
        state = const AsyncValue.data(null);
        // Refresh the inventory list
        _ref.invalidate(inventoryListProvider);
        _ref.invalidate(homeProductsProvider);
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteProduct(id);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (_) {
        state = const AsyncValue.data(null);
        // Refresh the inventory list
        _ref.invalidate(inventoryListProvider);
        _ref.invalidate(homeProductsProvider);
      },
    );
  }
}

final addProductProvider = StateNotifierProvider<AddProductNotifier, AsyncValue<void>>((ref) {
  return AddProductNotifier(ref.watch(inventoryRepositoryProvider), ref);
});

final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  final result = await repository.getCategories();
  return result.fold(
    (failure) => throw failure.message,
    (list) => list.map((json) => ProductCategory.fromJson(json as Map<String, dynamic>)).toList(),
  );
});
