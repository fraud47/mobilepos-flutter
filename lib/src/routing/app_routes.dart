/// Centralized route path constants for GoRouter.
///
/// Use these variables instead of raw strings throughout the app.
/// Example: `context.go(AppRoutes.onboarding)` instead of `context.go('/')`.
abstract final class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String inventoryManagement = '/inventory-management';
  static const String inventoryPage = '/inventory-page';
  static const String customerManagement = '/customer-management';
  static const String receiptManagement = '/receipt-management';
  static const String receiptDetail = '/receipt-detail';
  static const String usersList = '/users-list';
  static const String addUser = '/add-user';
  static const String unitOfMeasure = '/unit-of-measure';
  static const String branchesManagement = '/branches-management';
}
