import 'package:dio/dio.dart';
import '../../../../../config/app_config.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import '../../../domain/entities/inventory_item.dart';
import '../remote/inventory_remote_datasource.dart';

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  InventoryRemoteDataSourceImpl._();

  static final InventoryRemoteDataSourceImpl instance = InventoryRemoteDataSourceImpl._();

  Dio get dio => AppConfig.dio;

  @override
  Future<List<InventoryItem>> getInventory({int? branchId}) async {
    try {
      final response = await dio.get(
        '/api/v1/products/catalog/bundle',
        queryParameters: branchId != null ? {'branchId': branchId} : null,
      );
      final responseData = response.data;
      if (responseData == null || responseData['data'] == null) {
        return [];
      }
      
      final data = responseData['data'];
      final products = data['products'];
      if (products is List) {
        return products.map((json) => InventoryItem.fromJson(json)).toList();
      } else if (data is List) {
        return data.map((json) => InventoryItem.fromJson(json)).toList();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List).map((json) => InventoryItem.fromJson(json)).toList();
      }
      
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to fetch inventory',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<InventoryItem> createProduct(Map<String, dynamic> payload) async {
    try {
      print('=== SENDING CREATE PRODUCT PAYLOAD ===');
      print(payload);
      final response = await dio.post('/api/v1/products', data: payload);
      final responseData = response.data;
      if (responseData != null && responseData['data'] != null) {
        return InventoryItem.fromJson(responseData['data']);
      }
      throw const ServerException(message: 'Invalid response from server');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to create product',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<InventoryItem> updateProduct(String id, Map<String, dynamic> payload) async {
    try {
      final response = await dio.put('/api/v1/products/$id', data: payload);
      final responseData = response.data;
      if (responseData != null && responseData['data'] != null) {
        return InventoryItem.fromJson(responseData['data']);
      }
      throw const ServerException(message: 'Invalid response from server');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to update product',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await dio.delete('/api/v1/products/$id');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to delete product',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await dio.get('/api/v1/categories');
      final responseData = response.data;
      if (responseData != null && responseData['data'] is List) {
        return responseData['data'] as List<dynamic>;
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to fetch categories',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<dynamic> createCategory(String name) async {
    try {
      final response = await dio.post('/api/v1/categories', data: {'name': name});
      final responseData = response.data;
      if (responseData != null && responseData['data'] != null) {
        return responseData['data'];
      }
      throw const ServerException(message: 'Invalid response from server');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to create category',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  @override
  Future<dynamic> updateCategory(int id, String name) async {
    try {
      final response = await dio.put('/api/v1/categories/$id', data: {'name': name});
      final responseData = response.data;
      if (responseData != null && responseData['data'] != null) {
        return responseData['data'];
      }
      throw const ServerException(message: 'Invalid response from server');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to update category',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      await dio.delete('/api/v1/categories/$id');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to delete category',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
