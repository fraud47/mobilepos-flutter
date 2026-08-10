

import '../../../../imports/core_imports.dart';
import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  FutureEither<AuthSessionEntity> login({
    required String email,
    required String password,
  });

  FutureEither<AuthSessionEntity> signup({
    required String companyName,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerDisplayName,
  });
  FutureEither<void> forgotPassword({
    required String email,

  });

  FutureEither<AuthSessionEntity?> getCurrentSession();

  FutureEither<void> refreshSessionToken();

  FutureEither<void> logout();
}