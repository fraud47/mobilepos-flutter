import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../utils/utils.dart';
import '../../../../config/app_config.dart';
import '../../utils/secure_token_storage.dart';


class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  Dio get _dio => AppConfig.dio;

  final SecureTokenStorage _tokenStorage =
      SecureTokenStorage.instance;

  final StreamController<Map<String, dynamic>?> _authStateController =
  StreamController<Map<String, dynamic>?>.broadcast();

  Stream<Map<String, dynamic>?> get authStateChanges =>
      _authStateController.stream;


  FutureEither<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response =
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data;

      if (responseData == null) {
        return left(
          const ServerFailure(
            'No response received from server',
          ),
        );
      }

      // ---------------------------------------------------------
      // Check API-level success
      // ---------------------------------------------------------

      if (responseData['success'] != true) {
        return left(
          ServerFailure(
            responseData['message']?.toString() ??
                'Login failed',
          ),
        );
      }

      // ---------------------------------------------------------
      // Extract data
      // ---------------------------------------------------------

      final data = responseData['data'];

      if (data is! Map) {
        return left(
          const ServerFailure(
            'Login response is missing data',
          ),
        );
      }

      final loginData = Map<String, dynamic>.from(data);

      // ---------------------------------------------------------
      // Extract tokens
      // ---------------------------------------------------------

      final accessToken =
      loginData['accessToken']?.toString();

      final refreshToken =
      loginData['refreshToken']?.toString();

      if (accessToken == null ||
          accessToken.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        return left(
          const ServerFailure(
            'Login response is missing authentication tokens',
          ),
        );
      }

      // ---------------------------------------------------------
      // Save tokens securely
      // ---------------------------------------------------------

      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      // ---------------------------------------------------------
      // Extract user
      // ---------------------------------------------------------

      final userData = loginData['user'];

      if (userData is! Map) {
        return left(
          const ServerFailure(
            'Login response is missing user data',
          ),
        );
      }

      final user = Map<String, dynamic>.from(userData);
      _authStateController.add(user);

      // Return the complete API response to the repository.
      return right(responseData);
    } on DioException catch (e) {
      return left(
        _handleDioException(e),
      );
    } catch (e) {
      return left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // SIGN UP
  // ---------------------------------------------------------------------------

  FutureEither<Map<String, dynamic>?> signUp({
    required String companyName,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerDisplayName,
  }) async {
    try {
      final response =
      await _dio.post(
        '/api/v1/tenants',
        data: {
          'companyName': companyName,
          'ownerEmail': ownerEmail,
          'ownerPassword': ownerPassword,
          'ownerDisplayName': ownerDisplayName,
        },
      );
         debugPrint('signhjk');
      final responseData = response.data;

      if (responseData == null) {
        return left(
          const ServerFailure(
            'No response received from server',
          ),
        );
      }

      if (responseData['success'] != true) {
        return left(
          ServerFailure(
            responseData['message']?.toString() ??
                'Sign up failed',
          ),
        );
      }

      final data = responseData['data'];

      if (data is! Map) {
        return left(
          const ServerFailure(
            'Sign up response is missing data',
          ),
        );
      }

      final signupData =
      Map<String, dynamic>.from(data);

      final userData = signupData['user'];

      if (userData is! Map) {
        return left(
          const ServerFailure(
            'Sign up response is missing user data',
          ),
        );
      }

      final user = Map<String, dynamic>.from(userData);

      _authStateController.add(user);

      return right(responseData);
    } on DioException catch (e) {
      debugPrint('ERROR: ${e.message}');
      return left(
        _handleDioException(e),
      );
    } catch (e) {
      return left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // FORGOT PASSWORD
  // ---------------------------------------------------------------------------

  FutureEither<void> forgotPassword({
    required String email,
  }) async {
    try {
      await _dio.post<void>(
        '/auth/forgot-password',
        data: {
          'email': email,
        },
      );

      return right(null);
    } on DioException catch (e) {
      return left(
        _handleDioException(e),
      );
    } catch (e) {
      return left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }


  FutureEither<void> logout() async {
    try {
      final refreshToken =
      await _tokenStorage.getRefreshToken();

      if (refreshToken != null &&
          refreshToken.isNotEmpty) {
        try {
          await _dio.post<void>(
            '/api/v1/auth/logout',
            data: {
              'refreshToken': refreshToken,
            },
          );
        } catch (_) {
          // Ignore server logout errors.
          //
          // Local credentials must still be cleared.
        }
      }

      // Always clear local tokens.
      await _tokenStorage.clear();

      // Notify listeners.
      _authStateController.add(null);

      return right(null);
    } catch (e) {
      // Make sure local session is cleared even if
      // something unexpected happens.
      await _tokenStorage.clear();

      _authStateController.add(null);

      return left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // GET CURRENT USER
  // ---------------------------------------------------------------------------

  FutureEither<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final accessToken =
      await _tokenStorage.getAccessToken();

      if (accessToken == null ||
          accessToken.isEmpty) {
        debugPrint('token not found');
        _authStateController.add(null);

        return right(null);
      }

      final response =
      await _dio.get<Map<String, dynamic>>(
        '4/tenants/current',
      );

      final responseData = response.data;

      if (responseData == null) {
        _authStateController.add(null);

        return right(null);
      }


      final data = responseData['data'];

      Map<String, dynamic> user;

      if (data is Map && data['user'] is Map) {
        user = Map<String, dynamic>.from(
          data['user'],
        );
      } else if (data is Map) {
        user = Map<String, dynamic>.from(
          data,
        );
      } else {
        user = responseData;
      }

      _authStateController.add(user);

      return right(responseData);
    } on DioException catch (e) {
      // Access token is no longer valid.
      if (e.response?.statusCode == 401) {
        await _tokenStorage.clear();

        _authStateController.add(null);

        return right(null);
      }

      return left(
        _handleDioException(e),
      );
    } catch (e) {
      return left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // DIO ERROR HANDLER
  // ---------------------------------------------------------------------------

  ServerFailure _handleDioException(
      DioException e,
      ) {
    final responseData = e.response?.data;

    if (responseData is Map) {
      final message = responseData['message'];

      if (message != null &&
          message.toString().isNotEmpty) {
        return ServerFailure(
          message.toString(),
        );
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const ServerFailure(
        'Connection timed out. Please try again.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return const ServerFailure(
        'Unable to connect to the server.',
      );
    }

    return ServerFailure(
      e.message ?? 'Something went wrong',
    );
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  void dispose() {
    _authStateController.close();
  }
}