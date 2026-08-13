import '../../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveLoginData(AuthSessionModel session);

  Future<AuthSessionModel?> getCurrentSession();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<bool> hasPermission(String permission);

  /// Persists only the access token (refresh token unchanged).
  Future<void> updateAccessToken(String accessToken);

  /// Persists both tokens atomically — required after a token rotation so
  /// the new refresh token is saved before the old one is invalidated.
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> clearSession();
}