
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/app_config.dart';
import '../../../../core/databases/database_provider.dart';
import '../../data/data_sources/impl/auth_local_datasource_impl.dart';
import '../../data/data_sources/impl/auth_remote_datasource_impl.dart';
import '../../data/data_sources/local/auth_local_datasource.dart';
import '../../data/data_sources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../utils/auth_secure_storage.dart';




// =============================================================================
// SECURE STORAGE
// =============================================================================

final authSecureStorageProvider =
Provider<AuthSecureStorage>((ref) {
  return AuthSecureStorage();
});


// =============================================================================
// AUTH LOCAL DATA SOURCE
// =============================================================================

final authLocalDataSourceProvider =
Provider<AuthLocalDataSource>((ref) {
  final database = ref.watch(
    appDatabaseProvider,
  );

  final secureStorage = ref.read(
    authSecureStorageProvider,
  );

  return AuthLocalDataSourceImpl(
    database: database,
    secureStorage: secureStorage,
  );
});


// =============================================================================
// AUTH REMOTE DATA SOURCE
// =============================================================================

final authRemoteDataSourceProvider =
Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl.instance;
});


// =============================================================================
// AUTH REPOSITORY
// =============================================================================

final authRepositoryProvider =
Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(
    authRemoteDataSourceProvider,
  );

  final localDataSource = ref.read(
    authLocalDataSourceProvider,
  );

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});


// =============================================================================
// SESSION PROVIDER
// =============================================================================

final sessionProvider = StateNotifierProvider<
    SessionNotifier,
    SessionState>((ref) {
  final repository = ref.read(
    authRepositoryProvider,
  );

  return SessionNotifier(
    repository: repository,
  );
});


// =============================================================================
// SESSION STATUS
// =============================================================================

enum SessionStatus {
  unknown,
  authenticated,
  unauthenticated,
  forgotDone,
  forgotFailed
}


// =============================================================================
// SESSION STATE
// =============================================================================

class SessionState {
  final SessionStatus status;
  final AuthSessionEntity? session;

  const SessionState({
    this.status = SessionStatus.unknown,
    this.session,
  });

  bool get isLoading =>
      status == SessionStatus.unknown;

  bool get isAuthenticated =>
      status == SessionStatus.authenticated;

  bool get isUnauthenticated =>
      status == SessionStatus.unauthenticated;

  UserEntity? get user =>
      session?.user;

  TenantEntity? get tenant =>
      session?.tenant;

  List<CompanyEntity> get companies =>
      session?.companies ?? const [];

  List<String> get permissions =>
      session?.permissions ?? const [];

  bool hasPermission(
      String permission,
      ) {
    return session?.hasPermission(
      permission,
    ) ??
        false;
  }
}


// =============================================================================
// SESSION NOTIFIER
// =============================================================================

class SessionNotifier
    extends StateNotifier<SessionState> {
  SessionNotifier({
    required AuthRepository repository,
  })  : _repository = repository,
        super(const SessionState()) {
    _init();
    AppConfig.onUnauthenticated.stream.listen((_) {
      logout();
    });
  }

  final AuthRepository _repository;


  // ===========================================================================
  // INITIALIZE SESSION
  // ===========================================================================

  Future<void> _init() async {
    debugPrint(
      'SESSION: Initializing...',
    );

    try {
      final result =
      await _repository.getCurrentSession();

      result.fold(
            (failure) {
          debugPrint(
            'SESSION: Failed to restore session: '
                '${failure.message}',
          );

          state = const SessionState(
            status:
            SessionStatus.unauthenticated,
          );
        },
            (session) {
          if (session == null) {
            debugPrint(
              'SESSION: No authenticated session',
            );

            state = const SessionState(
              status:
              SessionStatus.unauthenticated,
            );

            return;
          }

          debugPrint(
            'SESSION: Restored session for '
                '${session.user.email}',
          );

          state = SessionState(
            status:
            SessionStatus.authenticated,
            session: session,
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint(
        'SESSION: Initialization error: $e',
      );

      debugPrint(
        stackTrace.toString(),
      );

      state = const SessionState(
        status:
        SessionStatus.unauthenticated,
      );
    }
  }


  // ===========================================================================
  // LOGIN
  // ===========================================================================
  Future<bool> forgotPassword({
    required String email,
  }) async {


    final result =
    await _repository.forgotPassword(
      email: email,
    );

    return result.fold(
          (failure) {
        state =
        const SessionState(
          status: SessionStatus.forgotFailed
        );

        return false;
      },
          (_) {
        state =
        const SessionState(
            status: SessionStatus.forgotDone
        );

        return true;
      },
    );
  }
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    debugPrint(
      'AUTH: Login started',
    );

    final result =
    await _repository.login(
      email: email,
      password: password,
    );

    return result.fold(
          (failure) {
        debugPrint(
          'AUTH: Login failed: '
              '${failure.message}',
        );

        return failure.message;
      },
          (session) {
        debugPrint(
          'AUTH: Login successful: '
              '${session.user.email}',
        );

        state = SessionState(
          status:
          SessionStatus.authenticated,
          session: session,
        );

        return null;
      },
    );
  }

  Future<String?> signUp({
    required String companyName,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerDisplayName,
  }) async {
    state =
    const SessionState(
        status: SessionStatus.unknown
    );

    final result =
    await _repository.signup(
      companyName: companyName,
      ownerEmail: ownerEmail,
      ownerPassword: ownerPassword,
      ownerDisplayName: ownerDisplayName,
    );

    return result.fold(
          (failure) {
            state =
            const SessionState(
                status: SessionStatus.unauthenticated
            );

        return failure.message;
      },
          (session) {
            state = SessionState(
              status: SessionStatus.authenticated,
              session: session,
            );

        return null;
      },
    );
  }

  Future<void> logout() async {
    debugPrint(
      'AUTH: Logging out...',
    );

    final result =
    await _repository.logout();

    result.fold(
          (failure) {
        debugPrint(
          'AUTH: Logout error: '
              '${failure.message}',
        );
      },
          (_) {
        debugPrint(
          'AUTH: Logout successful',
        );
      },
    );

    state = const SessionState(
      status:
      SessionStatus.unauthenticated,
    );
  }


  // ===========================================================================
  // REFRESH SESSION
  // ===========================================================================

  Future<bool> refreshSession() async {
    debugPrint(
      'SESSION: Refreshing session...',
    );

    final result =
    await _repository.getCurrentSession();

    return result.fold(
          (failure) {
        debugPrint(
          'SESSION: Refresh failed: '
              '${failure.message}',
        );

        state = const SessionState(
          status:
          SessionStatus.unauthenticated,
        );

        return false;
      },
          (session) {
        if (session == null) {
          debugPrint(
            'SESSION: No session found',
          );

          state = const SessionState(
            status:
            SessionStatus.unauthenticated,
          );

          return false;
        }

        debugPrint(
          'SESSION: Session refreshed',
        );

        state = SessionState(
          status:
          SessionStatus.authenticated,
          session: session,
        );

        return true;
      },
    );
  }

  // ===========================================================================
  // PROACTIVE REFRESH
  // ===========================================================================
  Future<void> proactiveTokenRefresh() async {
    if (state.status != SessionStatus.authenticated) return;
    debugPrint('SESSION: Proactively refreshing token due to movement...');
    final result = await _repository.refreshSessionToken();
    result.fold(
      (failure) {
        debugPrint('SESSION: Proactive refresh failed: ${failure.message}');
      },
      (_) {
        debugPrint('SESSION: Proactive refresh succeeded.');
        // Optionally reload the session from storage to get the new token if needed by the state,
        // but typically the Dio interceptor just reads from secure storage directly,
        // so we don't necessarily need to update the SessionState here.
      },
    );
  }


  // ===========================================================================
  // PERMISSION CHECK
  // ===========================================================================

  bool hasPermission(
      String permission,
      ) {
    return state.hasPermission(
      permission,
    );
  }
}