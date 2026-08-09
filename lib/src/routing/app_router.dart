
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/features/units_of_measure/presentation/screens/unit_of_measure_screen.dart';
import 'package:mobilepos/src/routing/global_navigator.dart';
import 'package:mobilepos/src/routing/app_routes.dart';
import 'package:mobilepos/src/features/auth/presentation/screens/login_screen.dart';
import 'package:mobilepos/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:mobilepos/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:mobilepos/src/features/home/presentation/screens/home_page.dart';
import 'package:mobilepos/src/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:mobilepos/src/features/customer/presentation/screens/customers_screen.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/management.dart';
import 'package:mobilepos/src/features/reciepts/presentation/screens/reciepts_screen.dart';
import 'package:mobilepos/src/features/users/presentation/screens/users_list.dart';
import 'package:mobilepos/src/features/users/presentation/screens/user_create.dart';
import 'package:mobilepos/src/routing/router_refresh_notifier.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerRefresh =
  ref.watch(routerRefreshProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,


    initialLocation: AppRoutes.signup,
    refreshListenable: routerRefresh,

    redirect: (context, state) {
      final session = ref.read(sessionProvider);

      final isAuthenticated = session.status == SessionStatus.authenticated;
      final isCheckingSession = session.status == SessionStatus.unknown;

      final isLogin = state.matchedLocation == AppRoutes.login;
      final isSignup = state.matchedLocation == AppRoutes.signup;
      final isForgotPassword = state.matchedLocation == AppRoutes.forgotPassword;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      final isPublicRoute = isLogin || isSignup || isForgotPassword || isOnboarding;

      if (isCheckingSession) return null;

      if (!isAuthenticated) {
        return isPublicRoute ? null : AppRoutes.signup;
      }

      if (isAuthenticated && isPublicRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    // =======================================================================
    // ROUTES
    // =======================================================================

    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) {
          return const OnboardingPage();
        },
      ),

      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) {
          return const SignupScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          return const HomePage();
        },
      ),

      GoRoute(
        path: AppRoutes.customerManagement,
        name: 'customerManagement',
        builder: (context, state) {
          return const CustomersScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.receiptManagement,
        name: 'receiptManager',
        builder: (context, state) {
          return const ReceiptsScreen();
        },
      ),

      // ---------------------------------------------------------------------
      // USERS
      // ---------------------------------------------------------------------

      GoRoute(
        path: AppRoutes.usersList,
        name: 'usersList',
        builder: (context, state) {
          return const UsersScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.addUser,
        name: 'addUser',
        builder: (context, state) {
          return const AddUserScreen();
        },
      ),

      // ---------------------------------------------------------------------
      // INVENTORY
      // ---------------------------------------------------------------------

      GoRoute(
        path: AppRoutes.inventoryManagement,
        name: 'inventoryManagement',
        builder: (context, state) {
          return const InventoryPage();
        },
      ),

      GoRoute(
        path: AppRoutes.inventoryPage,
        name: 'inventoryPage',
        builder: (context, state) {
          return const InventoryScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.unitOfMeasure,
        name: 'unitOfMeasure',
        builder: (context, state) {
          return const UnitsOfMeasureScreen();
        },
      ),
    ],
  );
});

