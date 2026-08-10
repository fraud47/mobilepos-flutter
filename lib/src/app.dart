import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/features/auth/presentation/widgets/session_activity_manager.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final router = ref.watch(appRouterProvider);

    return SessionActivityManager(
      child: ScreenUtilWrapper(
        child: MaterialApp.router(
          title: 'mobilepos',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: buildLightTheme(),
          themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return SkeletonWrapper(
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}