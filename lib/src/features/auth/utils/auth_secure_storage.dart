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

  static const offlinePinKey =
      'auth_offline_pin';

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

  Future<void> saveOfflinePin(String pin) async {
    await _storage.write(
      key: offlinePinKey,
      value: pin,
    );
  }

  Future<String?> getOfflinePin() {
    return _storage.read(
      key: offlinePinKey,
    );
  }

  Future<bool> hasOfflinePin() async {
    final pin = await getOfflinePin();
    return pin != null && pin.isNotEmpty;
  }

  Future<void> clearOfflinePin() async {
    await _storage.delete(
      key: offlinePinKey,
    );
  }

  Future<void> clearTokens() async {
    await _storage.delete(
      key: accessTokenKey,
    );

    await _storage.delete(
      key: refreshTokenKey,
    );

    await clearOfflinePin();
  }
}