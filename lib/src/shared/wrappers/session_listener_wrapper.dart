import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';


class SessionListenerWrapper extends ConsumerWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SessionState>(sessionProvider, (prev, next) {
      if (next.status != SessionStatus.unknown) {

        FlutterNativeSplash.remove();
        if (next.status == SessionStatus.authenticated) {
          context.go(AppRoutes.home);
        } else if (next.status == SessionStatus.unauthenticated) {
          context.go(AppRoutes.login);
        }
      }
      else{
        context.go(AppRoutes.login);
      }
    });

    return child;
  }
}
