import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/providers/auth_provider.dart';

final routerRefreshProvider =
Provider<RouterRefreshNotifier>((ref) {
  return RouterRefreshNotifier(ref);
});
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen<SessionState>(
      sessionProvider,
          (previous, next) {
        notifyListeners();
      },
    );
  }
}