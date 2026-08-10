import 'package:mobilepos/src/features/home/presentation/widgets/sidebar/drawer.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/home_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final colorScheme = context.colors;
    final isCartPage =
        state.selectedTab == HomeTab.counter && state.hasCartItems;
    final title = _titleForTab(state.selectedTab);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: isCartPage ? colorScheme.surface : colorScheme.primary,
        statusBarIconBrightness:
            isCartPage ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        key: scaffoldKey,
        drawer: const AppDrawer(),
        backgroundColor: colorScheme.surface,
        bottomNavigationBar: isCartPage
            ? null
            : HomeBottomNav(
                selectedTab: state.selectedTab,
                cartCount: state.unitBadgeCount,
                onTabSelected: controller.selectTab,
              ),
        body: isCartPage
            ? HomeTabBody(
                state: state,
                onNewSale: controller.startNewSale,
                onProductSelected: controller.addProduct,
                onClearCart: controller.clearCart,
                onIncrementProduct: controller.incrementProduct,
                onDecrementProduct: controller.decrementProduct,
                onRemoveProduct: controller.removeProduct,
                onQuantityChanged: controller.updateProductQuantity,
              )
            : Column(
                children: [
                  HomeHeader(
                    onMenuPressed: () => scaffoldKey.currentState?.openDrawer(),
                    title: title,
                    selectedTab: state.selectedTab,
                    onNewSale: controller.startNewSale,
                  ),
                  Expanded(
                    child: HomeTabBody(
                      state: state,
                      onNewSale: controller.startNewSale,
                      onProductSelected: controller.addProduct,
                      onClearCart: controller.clearCart,
                      onIncrementProduct: controller.incrementProduct,
                      onDecrementProduct: controller.decrementProduct,
                      onRemoveProduct: controller.removeProduct,
                      onQuantityChanged: controller.updateProductQuantity,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _titleForTab(HomeTab tab) {
    return switch (tab) {
      HomeTab.reports => 'Reports',
      HomeTab.counter => 'Counter',
      HomeTab.items => 'Items',
    };
  }
}
