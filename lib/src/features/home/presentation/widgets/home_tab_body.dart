import 'package:mobilepos/src/features/cart/presentation/cart_page.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import '../screens/items_page.dart';
import '../screens/reports_page.dart';
import 'counter_home_view.dart';
import 'placeholder_tab.dart';

class HomeTabBody extends StatelessWidget {
  const HomeTabBody({
    super.key,
    required this.state,
    required this.onNewSale,
    required this.onProductSelected,
    required this.onClearCart,
    required this.onIncrementProduct,
    required this.onDecrementProduct,
    required this.onRemoveProduct,
    required this.onQuantityChanged,
  });

  final HomeState state;
  final VoidCallback onNewSale;
  final ValueChanged<InventoryItem> onProductSelected;
  final VoidCallback onClearCart;
  final ValueChanged<InventoryItem> onIncrementProduct;
  final ValueChanged<InventoryItem> onDecrementProduct;
  final ValueChanged<InventoryItem> onRemoveProduct;
  final ProductQuantityChanged onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return switch (state.selectedTab) {
      HomeTab.counter => state.hasCartItems
          ? CheckoutPage(
              state: state,
              onNewSale: onNewSale,
              onClearCart: onClearCart,
              onIncrementProduct: onIncrementProduct,
              onDecrementProduct: onDecrementProduct,
              onRemoveProduct: onRemoveProduct,
              onQuantityChanged: onQuantityChanged,
            )
          : CounterHomeView(onNewSale: onNewSale),
      HomeTab.items => ItemsPage(onProductSelected: onProductSelected),
      HomeTab.reports => const ReportsPage(),
    };
  }
}
