import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/auth/presentation/providers/auth_provider.dart';

class SessionActivityManager extends ConsumerStatefulWidget {
  final Widget child;
  
  const SessionActivityManager({super.key, required this.child});

  @override
  ConsumerState<SessionActivityManager> createState() => _SessionActivityManagerState();
}

class _SessionActivityManagerState extends ConsumerState<SessionActivityManager> {
  Timer? _idleTimer;
  Timer? _refreshTimer;

  // Configuration (as agreed in the plan)
  final Duration _idleTimeout = const Duration(minutes: 15);
  final Duration _refreshInterval = const Duration(minutes: 10);
  
  bool _hasMovementSinceLastRefresh = false;

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  void _startTimers() {
    _resetIdleTimer();
    
    // Proactive refresh timer
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (timer) {
      _handlePeriodicRefresh();
    });
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleTimeout, () {
      _handleIdleTimeout();
    });
  }

  void _handleIdleTimeout() {
    final sessionState = ref.read(sessionProvider);
    if (sessionState.isAuthenticated) {
      debugPrint('SESSION: User has been idle for $_idleTimeout. Logging out.');
      ref.read(sessionProvider.notifier).logout();
    }
  }

  void _handlePeriodicRefresh() {
    final sessionState = ref.read(sessionProvider);
    if (sessionState.isAuthenticated && _hasMovementSinceLastRefresh) {
      _hasMovementSinceLastRefresh = false; // Reset the flag
      ref.read(sessionProvider.notifier).proactiveTokenRefresh();
    }
  }

  void _handleUserInteraction([_]) {
    if (!_hasMovementSinceLastRefresh) {
      _hasMovementSinceLastRefresh = true;
    }
    _resetIdleTimer();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      onPointerMove: _handleUserInteraction,
      onPointerUp: _handleUserInteraction,
      child: widget.child,
    );
  }
}
