import 'package:fpdart/fpdart.dart';
import 'package:mobilepos/src/utils/failure.dart';
import 'package:mobilepos/src/utils/utils.dart';
import '../../domain/entities/inventory_item.dart';

abstract class InventoryRepository {
  FutureEither<List<InventoryItem>> getInventory({int? branchId});
  FutureEither<InventoryItem> createProduct(Map<String, dynamic> payload);
  FutureEither<InventoryItem> updateProduct(String id, Map<String, dynamic> payload);
  FutureEither<void> deleteProduct(String id);
  FutureEither<List<dynamic>> getCategories();
  FutureEither<dynamic> createCategory(String name);
  FutureEither<dynamic> updateCategory(int id, String name);
  FutureEither<void> deleteCategory(int id);
}
