import '../../../domain/entities/inventory_item.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItem>> getInventory({int? branchId});
  Future<InventoryItem> createProduct(Map<String, dynamic> payload);
  Future<InventoryItem> updateProduct(String id, Map<String, dynamic> payload);
  Future<void> deleteProduct(String id);
  Future<List<dynamic>> getCategories();
  Future<dynamic> createCategory(String name);
  Future<dynamic> updateCategory(int id, String name);
  Future<void> deleteCategory(int id);
}
