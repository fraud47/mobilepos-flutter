import 'package:fpdart/fpdart.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import 'package:mobilepos/src/utils/typedefs.dart';
import 'package:mobilepos/src/utils/failure.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/branch_repository.dart';
import '../models/create_branch_dto.dart';
import '../data_sources/remote/branch_remote_datasource.dart';

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource remoteDataSource;

  BranchRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<Branch>> getBranches(int tenantId) async {
    try {
      final result = await remoteDataSource.getBranches(tenantId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<Branch> createBranch(int tenantId, CreateBranchDto dto) async {
    try {
      final result = await remoteDataSource.createBranch(tenantId, dto);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<Branch> updateBranch(int branchId, CreateBranchDto dto) async {
    try {
      final result = await remoteDataSource.updateBranch(branchId, dto);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deleteBranch(int branchId) async {
    try {
      await remoteDataSource.deleteBranch(branchId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
