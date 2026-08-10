import 'dart:async';

import '../features/auth/data/data_sources/local/auth_local_datasource.dart';
import '../features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import '../imports/core_imports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static late final Dio dio;

  static late final AuthLocalDataSource authLocalDataSource;

  static late final AuthRemoteDataSource authRemoteDataSource;

  static Timer? _refreshTimer;

  static final StreamController<void> onUnauthenticated = StreamController<void>.broadcast();

  // Prevent multiple refresh requests
  // from running at the same time.
  static Future<String?>? _refreshFuture;

  static String get baseUrl => _getBaseUrl();

  static Future<void> init({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  }) async {
    authLocalDataSource = localDataSource;

    authRemoteDataSource = remoteDataSource;

    dio = Dio(
      BaseOptions(
        baseUrl: _getBaseUrl(),
        connectTimeout:
        const Duration(seconds: 30),
        receiveTimeout:
        const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(

        // --------------------------------------------------
        // REQUEST
        // --------------------------------------------------
        onRequest: (
            options,
            handler,
            ) async {
          final accessToken =
          await authLocalDataSource
              .getAccessToken();

          if (accessToken != null &&
              accessToken.isNotEmpty) {
            options.headers[
            'Authorization'] =
            'Bearer $accessToken';
          }

          AppLogger.info(
            '🌐 [DIO] REQUEST[${options.method}] => PATH: ${options.path}',
          );

          return handler.next(options);
        },

        // --------------------------------------------------
        // RESPONSE
        // --------------------------------------------------
        onResponse: (
            response,
            handler,
            ) {
          AppLogger.info(
            '✅ [DIO] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );

          AppLogger.info(
            '✅ [DIO] RESPONSE DATA[${response.statusCode}] => DATA: ${response.data}',
          );

          return handler.next(response);
        },

        // --------------------------------------------------
        // ERROR
        // --------------------------------------------------
        onError: (
            DioException e,
            handler,
            ) async {
          final statusCode =
              e.response?.statusCode;

          AppLogger.error(
            '❌ [DIO] ERROR[$statusCode] => PATH: ${e.requestOptions.path}\n'
            '❌ DATA: ${e.response?.data}',
          );

          // Only refresh when server returns 401
          if (statusCode != 401) {
            return handler.next(e);
          }

          // Do not attempt to refresh if
          // the failed request is already
          // the refresh request.
          if (_isRefreshRequest(
            e.requestOptions,
          )) {
            AppLogger.error(
              '❌ Refresh endpoint returned 401',
            );
            
            onUnauthenticated.add(null);

            return handler.next(e);
          }

          try {
            AppLogger.info(
              '🔐 Access token expired. '
                  'Attempting to refresh token...',
            );

            final newAccessToken =
            await _refreshAccessTokenOnce();

            if (newAccessToken == null ||
                newAccessToken.isEmpty) {
              AppLogger.error(
                '❌ Could not refresh access token',
              );
              
              onUnauthenticated.add(null);

              return handler.next(e);
            }

            // Update original request
            e.requestOptions.headers[
            'Authorization'] =
            'Bearer $newAccessToken';

            AppLogger.info(
              '🔁 Retrying original request: '
                  '${e.requestOptions.path}',
            );

            // Retry original request
            final response =
            await dio.fetch(
              e.requestOptions,
            );

            return handler.resolve(
              response,
            );
          } catch (refreshError) {
            AppLogger.error(
              '❌ Token refresh failed: '
                  '$refreshError',
            );

            return handler.next(e);
          }
        },
      ),
    );

    // Optional proactive refresh
    _startTokenRefreshTimer();
  }

  // --------------------------------------------------
  // REFRESH TOKEN
  // --------------------------------------------------

  static Future<String?>
  _refreshAccessTokenOnce() async {

    // If another request is already
    // refreshing the token, wait for it.
    if (_refreshFuture != null) {
      return await _refreshFuture;
    }

    _refreshFuture =
        _refreshAccessToken();

    try {
      return await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  static Future<String?>
  _refreshAccessToken() async {
    try {
      final refreshToken =
      await authLocalDataSource
          .getRefreshToken();

      if (refreshToken == null ||
          refreshToken.isEmpty) {
        AppLogger.info(
          '🔐 No refresh token available',
        );

        return null;
      }

      AppLogger.info(
        '🔄 Refreshing access token...',
      );

      final newAccessToken =
      await authRemoteDataSource
          .refreshAccessToken(
        refreshToken: refreshToken,
      );

      await authLocalDataSource
          .updateAccessToken(
        newAccessToken,
      );

      AppLogger.info(
        '✅ Access token refreshed successfully',
      );

      return newAccessToken;
    } catch (e) {
      AppLogger.error(
        '❌ Failed to refresh access token: $e',
      );

      return null;
    }
  }

  // --------------------------------------------------
  // CHECK REFRESH REQUEST
  // --------------------------------------------------

  static bool _isRefreshRequest(
      RequestOptions options,
      ) {
    return options.path ==
        '/api/v1/auth/refresh-token';
  }

  // --------------------------------------------------
  // PROACTIVE REFRESH
  // --------------------------------------------------

  static void _startTokenRefreshTimer() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 5),
          (_) async {
        await _refreshAccessToken();
      },
    );
  }

  // --------------------------------------------------
  // DISPOSE
  // --------------------------------------------------

  static Future<void> dispose() async {
    _refreshTimer?.cancel();

    _refreshTimer = null;

    _refreshFuture = null;
    await onUnauthenticated.close();
  }

  // --------------------------------------------------
  // BASE URL
  // --------------------------------------------------

  static String _getBaseUrl() {
    final configuredUrl =
        dotenv.maybeGet(
          'API_BASE_URL',
        ) ??
            dotenv.maybeGet(
              'API_URL',
            ) ??
            'https://apkmechanic.com';

    final trimmedUrl =
    configuredUrl.trim();

    if (trimmedUrl.startsWith(
      'http://',
    ) ||
        trimmedUrl.startsWith(
          'https://',
        )) {
      return trimmedUrl;
    }

    return 'https://$trimmedUrl';
  }
}