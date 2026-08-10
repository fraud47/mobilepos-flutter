import 'package:dio/dio.dart';
import 'package:mobilepos/src/config/app_config.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import '../remote/branch_remote_datasource.dart';
import '../../models/branch_model.dart';
import '../../models/create_branch_dto.dart';

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  BranchRemoteDataSourceImpl._();

  static final BranchRemoteDataSourceImpl instance = BranchRemoteDataSourceImpl._();

  Dio get dio => AppConfig.dio;

  @override
  Future<List<BranchModel>> getBranches(int tenantId) async {
    try {
      final response = await dio.get('/api/v1/companies/$tenantId');
      final data = response.data['data'];
      
      if (data != null && data['branches'] is List) {
        return (data['branches'] as List).map((json) => BranchModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to fetch branches',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BranchModel> createBranch(int tenantId, CreateBranchDto dto) async {
    try {
      final response = await dio.post(
        '/api/v1/companies/$tenantId/branches',
        data: dto.toJson(),
      );
      return BranchModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to create branch',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BranchModel> updateBranch(int branchId, CreateBranchDto dto) async {
    try {
      final response = await dio.put(
        '/api/v1/branches/$branchId',
        data: dto.toJson(),
      );
      return BranchModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to update branch',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteBranch(int branchId) async {
    try {
      await dio.delete('/api/v1/branches/$branchId');
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to delete branch',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
