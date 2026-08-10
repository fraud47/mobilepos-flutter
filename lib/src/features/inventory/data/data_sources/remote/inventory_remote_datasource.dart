import '../../../domain/entities/inventory_item.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItem>> getInventory({int? branchId});
  Future<InventoryItem> createProduct(Map<String, dynamic> payload);
  Future<void> deleteProduct(String id);
}
