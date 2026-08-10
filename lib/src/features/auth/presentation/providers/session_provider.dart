import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';

enum SessionStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class SessionState {
  final SessionStatus status;
  final AuthSessionEntity? session;

  const SessionState({
    required this.status,
    this.session,
  });

  const SessionState.unknown()
      : status = SessionStatus.unknown,
        session = null;

  const SessionState.authenticated(
      AuthSessionEntity session,
      )   : status = SessionStatus.authenticated,
        session = session;

  const SessionState.unauthenticated()
      : status = SessionStatus.unauthenticated,
        session = null;

  bool get isLoading =>
      status == SessionStatus.unknown;

  bool get isAuthenticated =>
      status == SessionStatus.authenticated;

  bool get isUnauthenticated =>
      status == SessionStatus.unauthenticated;
}

class SessionNotifier
    extends StateNotifier<SessionState> {
  final AuthRepository _authRepository;

  SessionNotifier({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const SessionState.unknown()) {
    checkAuthState();
  }

  // ============================================================
  // CHECK CURRENT SESSION
  // ============================================================

  Future<void> checkAuthState() async {
    state = const SessionState.unknown();

    final result =
    await _authRepository.getCurrentSession();

    result.fold(
          (failure) {
        state =
        const SessionState.unauthenticated();
      },
          (session) {
        if (session == null) {
          state =
          const SessionState.unauthenticated();
        } else {
          state =
              SessionState.authenticated(
                session,
              );
        }
      },
    );
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    state = const SessionState.unknown();

    final result =
    await _authRepository.login(
      email: email,
      password: password,
    );

    return result.fold(
          (failure) {
        state =
        const SessionState.unauthenticated();

        return failure.message;
      },
          (session) {
        state =
            SessionState.authenticated(
              session,
            );

        return null;
      },
    );
  }

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<String?> signUp({
    required String companyName,
    required String ownerEmail,
    required String ownerPassword,
    required String ownerDisplayName,
  }) async {
    state = const SessionState.unknown();

    final result =
    await _authRepository.signup(
      companyName: companyName,
      ownerEmail: ownerEmail,
      ownerPassword: ownerPassword,
      ownerDisplayName: ownerDisplayName,
    );

    return result.fold(
          (failure) {
        state =
        const SessionState.unauthenticated();

        return failure.message;
      },
          (session) {
        state =
            SessionState.authenticated(
              session,
            );

        return null;
      },
    );
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<bool> forgotPassword({
    required String email,
  }) async {
    state = const SessionState.unknown();

    final result =
    await _authRepository.forgotPassword(
      email: email,
    );

    return result.fold(
          (failure) {
        state =
        const SessionState.unauthenticated();

        return false;
      },
          (_) {
        state =
        const SessionState.unauthenticated();

        return true;
      },
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    state = const SessionState.unknown();

    final result =
    await _authRepository.logout();

    result.fold(
          (failure) {
        state =
        const SessionState.unauthenticated();
      },
          (_) {
        state =
        const SessionState.unauthenticated();
      },
    );
  }
}