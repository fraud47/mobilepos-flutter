import '../../models/auth_session_model.dart';

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

  Future<String> refreshAccessToken({
    required String refreshToken,
  });
}