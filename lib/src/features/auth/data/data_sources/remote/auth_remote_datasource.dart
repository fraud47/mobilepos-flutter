import '../../models/auth_session_model.dart';

/// Pair of tokens returned by the refresh endpoint.
typedef RefreshResult = ({String accessToken, String refreshToken});

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });
  Future<AuthSessionModel> signUp({
    required String companyName,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerDisplayName,
  });
  Future<void> forgotPassword({
    required String email,
  });

  /// Calls POST /auth/refresh-token and returns **both** the new access token
  /// and the new refresh token (the backend uses rotation — the old refresh
  /// token is invalidated on every call, so we MUST persist the new one).
  Future<RefreshResult> refreshTokens({
    required String refreshToken,
  });
}