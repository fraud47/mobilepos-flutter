import 'package:dio/dio.dart';
import '../../../../../config/app_config.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../imports/core_imports.dart';
import '../../models/auth_session_model.dart';
import '../remote/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {

  Dio get dio => AppConfig.dio;
  AuthRemoteDataSourceImpl._();

  static final AuthRemoteDataSourceImpl instance = AuthRemoteDataSourceImpl._();

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post< Map<String, dynamic>>(
        '/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthSessionModel.fromJson(
        response.data!,
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
        e.response?.data?['message'] ??
            e.message ??
            'Login failed',
      );
    }
  }


  @override
  Future<AuthSessionModel> signUp({
    required String companyName,
    required String tenantSlug,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerDisplayName,
  }) async {
    try {
      final response = await dio.post<Map<String,dynamic>>(
      '/api/v1/tenants',
        data: {
          'companyName': companyName,
          'ownerEmail': ownerEmail,
          'ownerPassword': ownerPassword,
          'ownerDisplayName': ownerDisplayName
        },
      );

      final responseData =
      response.data as Map<String, dynamic>;

      final data =
      responseData['data']
      as Map<String, dynamic>;

      return AuthSessionModel.fromJson(data);
    } on DioException catch (e) {

      throw ServerException(
        message: e.response?.data?['message']?.toString() ??
            e.message ??
            'Unable to create account',
      );
    } catch (e) {
      throw ServerException(
       message:  e.toString(),
      );
    }
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {


      await dio.post(
        '/api/v1/auth/forgot-password',
        data: {
          'email': email.trim(),
        },
      );
    } on DioException catch (e) {

      final responseData = e.response?.data;

      String message = 'Unable to send password reset link';

      if (responseData is Map<String, dynamic>) {
        message =
            responseData['message']?.toString() ??
                message;
      }

      throw ServerException(message:message );
    } catch (e) {
      throw ServerException(
       message:  e.toString(),
      );
    }
  }


  @override
  Future<String> refreshAccessToken({
    required String refreshToken,
  }) async {
    try {
      final response =
      await dio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh-token',
        data: {
          'refreshToken': refreshToken,
        },
      );

      final responseData =
      response.data as Map<String, dynamic>;

      final data =
      responseData['data']
      as Map<String, dynamic>;

      return data['accessToken'] as String;
    } on DioException catch (e) {
      final responseData =
          e.response?.data;

      String message =
          'Unable to refresh access token';

      if (responseData
      is Map<String, dynamic>) {
        message =
            responseData['message']?.toString() ??
                message;
      }

      throw ServerException(
        message: message,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

}

