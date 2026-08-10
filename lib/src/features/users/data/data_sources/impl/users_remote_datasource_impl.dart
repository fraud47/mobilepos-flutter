import 'package:dio/dio.dart';
import '../../../../../config/app_config.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import '../../../domain/models/app_user.dart';
import '../remote/users_remote_datasource.dart';

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  UsersRemoteDataSourceImpl._();

  static final UsersRemoteDataSourceImpl instance = UsersRemoteDataSourceImpl._();

  Dio get dio => AppConfig.dio;

  @override
  Future<List<AppUser>> getUsers() async {
    try {
      final response = await dio.get('/api/v1/hr/employees');
      final responseData = response.data;
      if (responseData == null || responseData['data'] == null) {
        return [];
      }
      
      final data = responseData['data'];
      if (data is List) {
        return data.map((json) => AppUser.fromJson(json)).toList();
      } else if (data is Map && data['users'] is List) {
        return (data['users'] as List).map((json) => AppUser.fromJson(json)).toList();
      }
      
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to fetch users',
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
