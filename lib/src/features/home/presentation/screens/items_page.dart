import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:mobilepos/src/extensions/context_extension.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/cart/presentation/widgets/quantity_editor_sheet.dart';
import '../widgets/items/item_card.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Items Page
// ──────────────────────────────────────────────────────────────────────────────

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key, required this.onProductSelected});

  final ValueChanged<InventoryItem> onProductSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final productsAsync = ref.watch(filteredProductsProvider);
    final allProductsAsync = ref.watch(homeProductsProvider);

    return Column(
      children: [
        // ── Inventory Stats Header ──────────────────────────────────────────
        allProductsAsync.whenData((all) => all).when(
          data: (all) => _StatsHeader(products: all),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // ── Product List/Grid ───────────────────────────────────────────────
        Expanded(
          child: productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return _EmptyState(onClear: controller.hideItemSearch);
              }

              if (!state.isItemsGridView) {
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 20.h),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ItemCard(
                      item: product,
                      cartQuantity: state.quantityFor(product),
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
                padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 20.h),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 190.h,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ItemCard(
                    item: product,
                    cartQuantity: state.quantityFor(product),
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
            error: (error, _) => Center(
              child: Text(
                'Error loading items',
                style: TextStyle(color: Colors.red.shade400, fontSize: 13.sp),
              ),
            ),
          ),
        ),
      ],
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

// ──────────────────────────────────────────────────────────────────────────────
// Stats Header
// ──────────────────────────────────────────────────────────────────────────────

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({required this.products});
  final List<InventoryItem> products;

  @override
  Widget build(BuildContext context) {
    final total = products.length;
    final inStock = products.where((p) => p.stock >= 10).length;
    final low = products.where((p) => p.stock > 0 && p.stock < 10).length;
    final out = products.where((p) => p.stock <= 0).length;

    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 2.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatChip(
            label: 'Total',
            value: '$total',
            icon: FlutterRemix.store_2_line,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Spacer(),
          _StatChip(
            label: 'In Stock',
            value: '$inStock',
            icon: FlutterRemix.checkbox_circle_fill,
            color: const Color(0xFF15945B),
          ),
          SizedBox(width: 12.w),
          _StatChip(
            label: 'Low',
            value: '$low',
            icon: FlutterRemix.alert_fill,
            color: const Color(0xFFD97706),
          ),
          SizedBox(width: 12.w),
          _StatChip(
            label: 'Out',
            value: '$out',
            icon: FlutterRemix.close_circle_fill,
            color: const Color(0xFFDC2626),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.sp, color: color),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF151515),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Empty State
// ──────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FlutterRemix.search_line,
              size: 52.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 14.h),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF151515),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Try a different name, price or stock value.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 20.h),
            FilledButton.icon(
              onPressed: onClear,
              icon: Icon(FlutterRemix.close_line, size: 14.sp),
              label: const Text('Clear search'),
              style: FilledButton.styleFrom(
                backgroundColor: cs.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
