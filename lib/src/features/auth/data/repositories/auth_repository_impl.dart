
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../imports/core_imports.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/local/auth_local_datasource.dart';
import '../data_sources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  FutureEither<AuthSessionEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await remoteDataSource.login(
        email: email,
        password: password,

      );

      await localDataSource.saveLoginData(
        session,
      );

      return Right(
        session.toEntity(),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
           e.message,
        ),
      );
    }
  }
  @override
  FutureEither<void> forgotPassword({
    required String email,
  }) async {
    try {
      await remoteDataSource.forgotPassword(
        email: email,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  @override
  FutureEither<AuthSessionEntity?> getCurrentSession() async {
    try {
      final session =
      await localDataSource.getCurrentSession();

      if (session == null) {
        return const Right(null);
      }

      return Right(
        session,
      );
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          e.message,
        ),
      );
    } catch (e) {
      return Left(
        CacheFailure(
          e.toString(),
        ),
      );
    }
  }

  @override
  FutureEither<void> refreshSessionToken() async {
    try {
      final session = await localDataSource.getCurrentSession();
      if (session == null || session.refreshToken.isEmpty) {
        return const Left(ServerFailure('No refresh token available'));
      }

      final result = await remoteDataSource.refreshTokens(
        refreshToken: session.refreshToken,
      );

      // Save BOTH tokens — the backend rotates the refresh token on every call.
      await localDataSource.updateTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> logout() async {
    try {
      await localDataSource.clearSession();

      return const Right(null);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(e.message,
        ),
      );
    } catch (e) {
      return Left(
        CacheFailure(
          e.toString(),
        ),
      );
    }
  }

  @override
  FutureEither<AuthSessionEntity> signup({
    required String companyName,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerDisplayName,
  }) async {
    try {
      final session = await remoteDataSource.signUp(
          companyName: companyName,
          ownerEmail: ownerEmail,
          ownerPassword: ownerPassword,
          ownerDisplayName: ownerDisplayName
      );

      await localDataSource.saveLoginData(
        session,
      );

      return Right(
        session.toEntity(),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
        ),
      );
    }
  }

}
