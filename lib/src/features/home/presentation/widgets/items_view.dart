import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'product_tile.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key, required this.onProductSelected});

  final ValueChanged<InventoryItem> onProductSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(6.w),
      itemCount: homeProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.92,
        mainAxisSpacing: 4.h,
        crossAxisSpacing: 4.w,
      ),
      itemBuilder: (context, index) {
        final product = homeProducts[index];
        return InventoryCard(
          item: product,
          onTap: () => onProductSelected(product),
        );
      },
    );
  }
}
