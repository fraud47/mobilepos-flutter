import 'package:fpdart/fpdart.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import 'package:mobilepos/src/utils/utils.dart';
import 'package:mobilepos/src/utils/failure.dart';
import '../../domain/entities/inventory_item.dart';
import '../data_sources/remote/inventory_remote_datasource.dart';
import 'inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<InventoryItem>> getInventory({int? branchId}) async {
    try {
      final inventory = await remoteDataSource.getInventory(branchId: branchId);
      return right(inventory);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<InventoryItem> createProduct(Map<String, dynamic> payload) async {
    try {
      final product = await remoteDataSource.createProduct(payload);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<InventoryItem> updateProduct(String id, Map<String, dynamic> payload) async {
    try {
      final product = await remoteDataSource.updateProduct(id, payload);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<dynamic>> getCategories() async {
    try {
      final res = await remoteDataSource.getCategories();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<dynamic> createCategory(String name) async {
    try {
      final res = await remoteDataSource.createCategory(name);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  FutureEither<dynamic> updateCategory(int id, String name) async {
    try {
      final res = await remoteDataSource.updateCategory(id, name);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deleteCategory(int id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
