import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'bottom_nav_button.dart';
import 'home_models.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.selectedTab,
    required this.cartCount,
    required this.onTabSelected,
  });

  final HomeTab selectedTab;
  final int cartCount;
  final ValueChanged<HomeTab> onTabSelected;

  static const List<BottomNavItem> _items = [
    BottomNavItem(HomeTab.reports, 'Reports', FlutterRemix.bar_chart_line),
    BottomNavItem(HomeTab.counter, 'Cart', FlutterRemix.shopping_basket_line),
    BottomNavItem(HomeTab.items, 'Items', FlutterRemix.barcode_line),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return SafeArea(
      top: false,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: _items.map((item) {
            return Expanded(
              child: BottomNavButton(
                item: item,
                selected: item.tab == selectedTab,
                badgeCount: item.tab == HomeTab.counter ? cartCount : 0,
                onPressed: () => onTabSelected(item.tab),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
