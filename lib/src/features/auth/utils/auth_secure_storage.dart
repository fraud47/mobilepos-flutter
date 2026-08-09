import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSecureStorage {
  final FlutterSecureStorage _storage;

  AuthSecureStorage({
    FlutterSecureStorage? storage,
  }) : _storage =
      storage ?? const FlutterSecureStorage();

  static const accessTokenKey =
      'auth_access_token';

  static const refreshTokenKey =
      'auth_refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(
      key: accessTokenKey,
      value: accessToken,
    );

    await _storage.write(
      key: refreshTokenKey,
      value: refreshToken,
    );
  }

  Future<String?> getAccessToken() {
    return _storage.read(
      key: accessTokenKey,
    );
  }

  Future<String?> getRefreshToken() {
    return _storage.read(
      key: refreshTokenKey,
    );
  }

  Future<void> clearTokens() async {
    await _storage.delete(
      key: accessTokenKey,
    );

    await _storage.delete(
      key: refreshTokenKey,
    );
  }
}