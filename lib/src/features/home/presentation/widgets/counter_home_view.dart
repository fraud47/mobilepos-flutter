import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mobilepos/src/extensions/context_extension.dart';
import 'package:mobilepos/src/features/branches/presentation/providers/branch_provider.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';

// ---------------------------------------------------------------------------
// COUNTER HOME VIEW  — Modern POS Terminal
// ---------------------------------------------------------------------------

class CounterHomeView extends ConsumerStatefulWidget {
  const CounterHomeView({
    super.key,
    required this.onNewSale,
    required this.onProductSelected,
    required this.onIncrementProduct,
    required this.onDecrementProduct,
    required this.onRemoveProduct,
  });

  final VoidCallback onNewSale;
  final ValueChanged<InventoryItem> onProductSelected;
  final ValueChanged<InventoryItem> onIncrementProduct;
  final ValueChanged<InventoryItem> onDecrementProduct;
  final ValueChanged<InventoryItem> onRemoveProduct;

  @override
  ConsumerState<CounterHomeView> createState() => _CounterHomeViewState();
}

class _CounterHomeViewState extends ConsumerState<CounterHomeView> {
  final _searchController = TextEditingController();
  bool _isOrderPanelExpanded = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller with preserved search query
    _searchController.text = ref.read(homeControllerProvider).counterSearchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final hasCart = state.hasCartItems;

    return Column(
      children: [
        // ── Header ─────────────────────────────────────────────────────────
        _POSHeader(),

        // ── Search + Category bar ──────────────────────────────────────────
        _SearchBar(controller: _searchController, ref: ref),

        // ── Product grid ───────────────────────────────────────────────────
        Expanded(
          child: _ProductGrid(
            onProductSelected: (product) {
              controller.addProduct(product);
            },
          ),
        ),

        // ── Order panel ────────────────────────────────────────────────────
        if (hasCart)
          _OrderPanel(
            state: state,
            isExpanded: _isOrderPanelExpanded,
            onToggleExpand: () =>
                setState(() => _isOrderPanelExpanded = !_isOrderPanelExpanded),
            onIncrement: widget.onIncrementProduct,
            onDecrement: widget.onDecrementProduct,
            onRemove: widget.onRemoveProduct,
            onCheckout: widget.onNewSale,
          ),

        // ── Empty state CTA ────────────────────────────────────────────────
        if (!hasCart) _EmptyCTA(onNewSale: widget.onNewSale),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// POS HEADER
// ---------------------------------------------------------------------------

class _POSHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final activeBranch = ref.watch(activeBranchProvider);
    final branchName = activeBranch?.name ?? 'No Branch';

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Branch info
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child:
                  Icon(FlutterRemix.store_2_line, color: Colors.white, size: 18.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branchName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'POS Counter • $timeStr',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'OPEN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SEARCH BAR
// ---------------------------------------------------------------------------

class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar({required this.controller, required this.ref});
  final TextEditingController controller;
  final WidgetRef ref;

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final controller = ref.read(homeControllerProvider.notifier);

    return Container(
      color: cs.primary,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 12.w),
            Icon(
              FlutterRemix.search_2_line,
              size: 18.sp,
              color: cs.primary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: controller.setCounterSearchQuery,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Search products or scan barcode...',
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, value, child) {
                if (value.text.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      widget.controller.clear();
                      controller.setCounterSearchQuery('');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Icon(
                      FlutterRemix.barcode_box_line,
                      size: 18.sp,
                      color: Colors.grey.shade400,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PRODUCT GRID
// ---------------------------------------------------------------------------

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({required this.onProductSelected});
  final ValueChanged<InventoryItem> onProductSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(counterFilteredProductsProvider);
    final state = ref.watch(homeControllerProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FlutterRemix.search_eye_line,
                  size: 48.sp,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12.h),
                Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 135.h,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final qty = state.quantityFor(product);
            return _POSProductCard(
              product: product,
              cartQty: qty,
              onTap: () => onProductSelected(product),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error loading products',
          style: TextStyle(fontSize: 12.sp, color: Colors.red.shade400),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// POS PRODUCT CARD
// ---------------------------------------------------------------------------

class _POSProductCard extends StatelessWidget {
  const _POSProductCard({
    required this.product,
    required this.cartQty,
    required this.onTap,
  });

  final InventoryItem product;
  final double cartQty;
  final VoidCallback onTap;

  Color _categoryColor(String name) {
    final colors = [
      const Color(0xFF3191FF),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
    ];
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final inCart = cartQty > 0;
    final color = _categoryColor(product.name);
    final isOutOfStock = product.stock <= 0;

    return GestureDetector(
      onTap: isOutOfStock ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: inCart ? cs.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: inCart
                  ? cs.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: inCart ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product icon
                  Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        product.name.isNotEmpty
                            ? product.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Name
                  Expanded(
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF151515),
                        height: 1.2,
                      ),
                    ),
                  ),

                  // Price + stock row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? Colors.red.shade50
                              : product.stock < 5
                                  ? Colors.amber.shade50
                                  : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          isOutOfStock
                              ? 'Out'
                              : product.stock < 5
                                  ? '${product.stock}!'
                                  : '${product.stock}',
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                            color: isOutOfStock
                                ? Colors.red.shade600
                                : product.stock < 5
                                    ? Colors.amber.shade800
                                    : Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cart badge
            if (inCart)
              Positioned(
                top: 6.h,
                right: 6.w,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    formatQuantity(cartQty),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

            // Out of stock overlay
            if (isOutOfStock)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Out of\nStock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ORDER PANEL (mini cart at bottom)
// ---------------------------------------------------------------------------

class _OrderPanel extends ConsumerWidget {
  const _OrderPanel({
    required this.state,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onCheckout,
  });

  final HomeState state;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final ValueChanged<InventoryItem> onIncrement;
  final ValueChanged<InventoryItem> onDecrement;
  final ValueChanged<InventoryItem> onRemove;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle + summary
          GestureDetector(
            onTap: onToggleExpand,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Summary row
                  Row(
                    children: [
                      // Cart icon with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              FlutterRemix.shopping_cart_2_fill,
                              color: cs.primary,
                              size: 18.sp,
                            ),
                          ),
                          Positioned(
                            top: -4.h,
                            right: -4.w,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16.w,
                                minHeight: 16.w,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${state.itemCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.itemCount} item${state.itemCount != 1 ? 's' : ''} • ${formatQuantity(state.unitCount)} units',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              '\$${state.subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF151515),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Expand/collapse icon
                      AnimatedRotation(
                        turns: isExpanded ? 0 : 0.5,
                        duration: const Duration(milliseconds: 280),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Checkout button
                      GestureDetector(
                        onTap: onCheckout,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded item list
          if (isExpanded)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 220.h),
              child: ListView.separated(
                shrinkWrap: true,
                padding:
                    EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                itemCount: state.cartItems.length,
                separatorBuilder: (_, __) => Divider(
                  height: 12.h,
                  color: Colors.grey.shade100,
                ),
                itemBuilder: (context, i) {
                  final item = state.cartItems[i];
                  return _CartRow(
                    item: item,
                    onIncrement: () => onIncrement(item.product),
                    onDecrement: () => onDecrement(item.product),
                    onRemove: () => onRemove(item.product),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CART ROW
// ---------------------------------------------------------------------------

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final lineTotal = item.product.price * item.quantity;

    return Row(
      children: [
        // Name + price
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$${item.product.price.toStringAsFixed(2)} × ${formatQuantity(item.quantity)}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),

        // Qty stepper
        Row(
          children: [
            _StepperButton(
              icon: Icons.remove_rounded,
              onTap: onDecrement,
              color: cs.primary,
            ),
            Container(
              width: 32.w,
              alignment: Alignment.center,
              child: Text(
                formatQuantity(item.quantity),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _StepperButton(
              icon: Icons.add_rounded,
              onTap: onIncrement,
              color: cs.primary,
            ),
          ],
        ),

        SizedBox(width: 8.w),

        // Line total
        SizedBox(
          width: 54.w,
          child: Text(
            '\$${lineTotal.toStringAsFixed(2)}',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        SizedBox(width: 6.w),

        // Remove
        GestureDetector(
          onTap: onRemove,
          child: Icon(
            Icons.close_rounded,
            size: 14.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 13.sp, color: color),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EMPTY CTA
// ---------------------------------------------------------------------------

class _EmptyCTA extends StatelessWidget {
  const _EmptyCTA({required this.onNewSale});
  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onNewSale,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FlutterRemix.add_circle_fill,
                  color: Colors.white,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Tap a product above or press here to start a new sale',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
