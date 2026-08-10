import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/cart/presentation/widgets/quantity_editor_sheet.dart';
import '../widgets/items/item_card.dart';

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key, required this.onProductSelected});

  final ValueChanged<InventoryItem> onProductSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final productsAsync = ref.watch(filteredProductsProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return AppEmptyState(
            icon: FlutterRemix.search_line,
            title: 'No items found',
            subtitle: 'Try a different item name, price, or stock value.',
            actionLabel: 'Clear search',
            onAction: controller.hideItemSearch,
          );
        }

        if (!state.isItemsGridView) {
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
            itemCount: products.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductCard(
                product: product,
                state: state,
                isListTile: true,
                onTap: () => onProductSelected(product),
                onLongPress: () => _showQuantityEditor(
                  context,
                  product,
                  state,
                  controller,
                ),
              );
            },
          );
        }

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.92,
            mainAxisSpacing: 4.h,
            crossAxisSpacing: 4.w,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductCard(
              product: product,
              state: state,
              onTap: () => onProductSelected(product),
              onLongPress: () => _showQuantityEditor(
                context,
                product,
                state,
                controller,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  void _showQuantityEditor(
    BuildContext context,
    InventoryItem product,
    HomeState state,
    HomeController controller,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return QuantityEditorSheet(
          initialQuantity: state.quantityFor(product),
          onSave: (value) => controller.updateProductQuantity(product, value),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.state,
    required this.onTap,
    required this.onLongPress,
    this.isListTile = false,
  });

  final InventoryItem product;
  final HomeState state;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isListTile;

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      item: product,
      cartQuantity: state.quantityFor(product),
      isListTile: isListTile,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
