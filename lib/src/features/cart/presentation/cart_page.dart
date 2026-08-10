import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/cart/presentation/providers/checkout_controller.dart';
import '../domain/models/cart_item_visual.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/routing/app_routes.dart';
import 'package:mobilepos/src/features/branches/presentation/providers/branch_provider.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/round_icon_button.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({
    super.key,
    required this.state,
    required this.onNewSale,
    required this.onClearCart,
    required this.onIncrementProduct,
    required this.onDecrementProduct,
    required this.onRemoveProduct,
    required this.onQuantityChanged,
  });

  final HomeState state;
  final VoidCallback onNewSale;
  final VoidCallback onClearCart;
  final ValueChanged<InventoryItem> onIncrementProduct;
  final ValueChanged<InventoryItem> onDecrementProduct;
  final ValueChanged<InventoryItem> onRemoveProduct;
  final ProductQuantityChanged onQuantityChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = state.subtotal;
    final total = subtotal;

    return ColoredBox(
      color: const Color(0xFFF7F7F7),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 430.w),
            child: Column(
              children: [
                _CartHeader(
                  onBack: onNewSale,
                  onClearCart: onClearCart,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 18.h),
                    child: Column(
                      children: [
                        ...List.generate(state.cartItems.length, (index) {
                          final item = state.cartItems[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: CartItemCard(
                              item: item,
                              visual: CartItemVisual.forIndex(index),
                              onQuantityChanged: (value) =>
                                  onQuantityChanged(item.product, value),
                              onIncrement: () =>
                                  onIncrementProduct(item.product),
                              onDecrement: () =>
                                  onDecrementProduct(item.product),
                              onRemove: () => onRemoveProduct(item.product),
                            ),
                          );
                        }),
                        SizedBox(height: 6.h),
                        _OrderPanel(
                          subtotal: subtotal,
                          total: total,
                          onCheckout: () {
                            _showPaymentOptions(context, ref);
                          },
                        ),
                      ],
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

  void _showPaymentOptions(BuildContext context, WidgetRef ref) {
    // Capture the router and scaffold messenger BEFORE any unmounting can occur
    final router = GoRouter.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final checkoutState = ref.watch(checkoutControllerProvider);
            final isLoading = checkoutState.isLoading;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Payment Method',
                      style: Theme.of(bottomSheetContext).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(height: 20.h),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      ListTile(
                        leading: const Icon(FlutterRemix.money_dollar_circle_line, color: Colors.black),
                        title: const Text('Cash', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        onTap: () async {
                          // Trigger API call
                          final success = await ref.read(checkoutControllerProvider.notifier).checkoutCash(state);
                          
                          if (!success) {
                            // Show error
                            final error = ref.read(checkoutControllerProvider).error;
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(error?.toString() ?? 'Checkout failed'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Success!
                          Navigator.pop(bottomSheetContext); // close bottom sheet
                          
                          // Store the current state as a snapshot for the receipt
                          final finalState = state.copyWith();
                          
                          // Navigate FIRST to avoid unmounting the widget before routing
                          router.push(AppRoutes.receiptDetail, extra: finalState);
                          
                          // Clear the actual cart
                          onClearCart();
                        },
                      ),
                      ListTile(
                        leading: const Icon(FlutterRemix.bank_card_line, color: Colors.black),
                        title: const Text('Online Payment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        onTap: () {
                          Navigator.pop(bottomSheetContext); // close bottom sheet
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text('Online Payment is coming soon!')),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(FlutterRemix.close_line, color: Colors.red),
                        title: const Text('Cancel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
}

class _CartHeader extends ConsumerWidget {
  const _CartHeader({
    required this.onBack,
    required this.onClearCart,
  });

  final VoidCallback onBack;
  final VoidCallback onClearCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeBranch = ref.watch(activeBranchProvider);
    
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 8.h),
      child: Row(
        children: [
          RoundIconButton(
            icon: FlutterRemix.close_line,
            onPressed: onBack,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cart',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (activeBranch != null) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(FlutterRemix.building_2_fill, size: 12.sp, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text(
                        activeBranch.name,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          RoundIconButton(
            icon: FlutterRemix.delete_bin_2_line,
            foregroundColor: const Color(0xFFE92929),
            onPressed: onClearCart,
          ),
          SizedBox(width: 10.w),
          RoundIconButton(
            icon: FlutterRemix.search_line,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _OrderPanel extends StatelessWidget {
  const _OrderPanel({
    required this.subtotal,
    required this.total,
    required this.onCheckout,
  });

  final double subtotal;
  final double total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          _SummaryLine(
            label: 'Subtotals for products:',
            value: '\$${subtotal.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8.h),
          _SummaryLine(
            label: 'VAT 15.5%',
            value: '\$${(total * 0.155).toStringAsFixed(2)}',
            isTotal: true,
          ),
          SizedBox(height: 5.h),
          _SummaryLine(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: FilledButton(
              onPressed: onCheckout,
              style: FilledButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final color = isTotal ? Colors.black : const Color(0xFFADADAD);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 11.sp,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
