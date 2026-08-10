
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
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/management.dart';
import 'package:mobilepos/src/features/reciepts/presentation/screens/reciepts_screen.dart';
import 'package:mobilepos/src/features/reciepts/presentation/screens/receipt_detail_screen.dart';
import 'package:mobilepos/src/features/users/presentation/screens/users_list.dart';
import 'package:mobilepos/src/features/users/presentation/screens/user_create.dart';
import 'package:mobilepos/src/features/branches/presentation/screens/branches_screen.dart';
import 'package:mobilepos/src/routing/router_refresh_notifier.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/categories_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import 'package:mobilepos/src/features/reciepts/presentation/screens/historical_receipt_detail_screen.dart';
import 'package:mobilepos/src/features/reciepts/domain/entities/reciept.dart';
import 'package:mobilepos/src/features/profile/presentation/screens/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerRefresh =
  ref.watch(routerRefreshProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,


    initialLocation: AppRoutes.login,
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
        return isPublicRoute ? null : AppRoutes.login;
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

      GoRoute(
        path: AppRoutes.receiptDetail,
        name: 'receiptDetail',
        builder: (context, state) {
          // Expecting HomeState to be passed as extra to render the receipt
          final homeState = state.extra as HomeState;
          return ReceiptDetailScreen(state: homeState);
        },
      ),
      GoRoute(
        path: AppRoutes.historicalReceiptDetail,
        name: 'historicalReceiptDetail',
        builder: (context, state) {
          final receipt = state.extra as Receipt;
          return HistoricalReceiptDetailScreen(receipt: receipt);
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
          final item = state.extra as InventoryItem?;
          return InventoryScreen(item: item);
        },
      ),
      GoRoute(
        path: AppRoutes.unitOfMeasure,
        name: 'unitOfMeasure',
        builder: (context, state) {
          return const UnitsOfMeasureScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.branchesManagement,
        name: 'branchesManagement',
        builder: (context, state) {
          return const BranchesScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.manageCategories,
        name: 'manageCategories',
        builder: (context, state) {
          return const CategoriesScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
    ],
  );
});

