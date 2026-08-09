import '../../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveLoginData(
      AuthSessionModel session,
      );

  Future<AuthSessionModel?> getCurrentSession();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<bool> hasPermission(
      String permission,
      );
  Future<void> updateAccessToken(
      String accessToken,
      );
  Future<void> clearSession();
}