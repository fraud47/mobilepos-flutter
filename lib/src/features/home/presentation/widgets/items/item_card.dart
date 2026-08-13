import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Stock status helper
// ──────────────────────────────────────────────────────────────────────────────

enum _StockStatus { good, low, out }

extension _StockStatusX on _StockStatus {
  Color get color {
    return switch (this) {
      _StockStatus.good => const Color(0xFF15945B),
      _StockStatus.low  => const Color(0xFFD97706),
      _StockStatus.out  => const Color(0xFFDC2626),
    };
  }

  Color get bgColor {
    return switch (this) {
      _StockStatus.good => const Color(0xFFDCFCE7),
      _StockStatus.low  => const Color(0xFFFEF3C7),
      _StockStatus.out  => const Color(0xFFFEE2E2),
    };
  }

  String label(int stock) {
    return switch (this) {
      _StockStatus.good => '$stock in stock',
      _StockStatus.low  => 'Low: $stock',
      _StockStatus.out  => 'Out of stock',
    };
  }

  String shortLabel(int stock) {
    return switch (this) {
      _StockStatus.good => '$stock',
      _StockStatus.low  => '$stock ⚠',
      _StockStatus.out  => '0',
    };
  }
}

_StockStatus _statusOf(InventoryItem item) {
  if (item.stock <= 0) return _StockStatus.out;
  if (item.stock < 10) return _StockStatus.low;
  return _StockStatus.good;
}

// ──────────────────────────────────────────────────────────────────────────────
// ItemCard
// ──────────────────────────────────────────────────────────────────────────────

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onLongPress,
    required this.cartQuantity,
    this.isListTile = false,
  });

  final InventoryItem item;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final double cartQuantity;
  final bool isListTile;

  @override
  Widget build(BuildContext context) {
    final status = _statusOf(item);
    final inCart = cartQuantity > 0;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: inCart
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: inCart
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: inCart ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isListTile ? _listContent(context, status) : _gridContent(context, status),
      ),
    );
  }

  Widget _gridContent(BuildContext context, _StockStatus status) {
    final cs = Theme.of(context).colorScheme;
    final inCart = cartQuantity > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon area with cart badge overlay
        Stack(
          children: [
            _ProductIconBox(item: item),
            if (inCart)
              Positioned(
                top: 6.h,
                right: 6.w,
                child: _CartBadge(quantity: cartQuantity, color: cs.primary),
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7.w, 5.h, 7.w, 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: const Color(0xFF151515),
                ),
              ),
              SizedBox(height: 4.h),

              // Price + stock badge row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  // Stock badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: status.bgColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      status.shortLabel(item.stock),
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w800,
                        color: status.color,
                      ),
                    ),
                  ),
                ],
              ),

              // Category chip
              if (item.category != null && item.category!.isNotEmpty) ...[
                SizedBox(height: 6.h),
                _CategoryChip(category: item.category!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _listContent(BuildContext context, _StockStatus status) {
    final cs = Theme.of(context).colorScheme;
    final inCart = cartQuantity > 0;

    return SizedBox(
      height: 76.h,
      child: Row(
        children: [
          // Icon box
          SizedBox(
            width: 76.w,
            child: Stack(
              children: [
                Positioned.fill(child: _ProductIconBox(item: item, isListTile: true)),
                if (inCart)
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: _CartBadge(quantity: cartQuantity, color: cs.primary),
                  ),
              ],
            ),
          ),

          // Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name + SKU row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF151515),
                          ),
                        ),
                      ),
                      if (item.sku != null && item.sku!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            item.sku!,
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Category
                  if (item.category != null && item.category!.isNotEmpty)
                    _CategoryChip(category: item.category!, isListTile: true),

                  const Spacer(),

                  // Price + stock row
                  Row(
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                      if (item.costPrice != null && item.costPrice! > 0) ...[
                        SizedBox(width: 6.w),
                        Text(
                          'Cost: \$${item.costPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                      const Spacer(),

                      // Full stock status badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: status.bgColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == _StockStatus.out
                                  ? FlutterRemix.close_circle_fill
                                  : status == _StockStatus.low
                                      ? FlutterRemix.alert_fill
                                      : FlutterRemix.checkbox_circle_fill,
                              size: 9.sp,
                              color: status.color,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              status.label(item.stock),
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: status.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Product Icon Box
// ──────────────────────────────────────────────────────────────────────────────

class _ProductIconBox extends StatelessWidget {
  const _ProductIconBox({required this.item, this.isListTile = false});
  final InventoryItem item;
  final bool isListTile;

  Color _accentFor(String name) {
    final palette = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
      const Color(0xFFEC4899),
    ];
    return palette[name.length % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _accentFor(item.name);
    final borderRadius = isListTile
        ? BorderRadius.horizontal(left: Radius.circular(16.r))
        : const BorderRadius.vertical(top: Radius.circular(16));

    return ClipRRect(
      borderRadius: borderRadius,
      child: AspectRatio(
        aspectRatio: isListTile ? 1 : 1.4,
        child: ColoredBox(
          color: color.withValues(alpha: 0.1),
          child: Center(
            child: Text(
              item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: isListTile ? 26.sp : 28.sp,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Category Chip
// ──────────────────────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category, this.isListTile = false});
  final String category;
  final bool isListTile;

  Color _accentFor(String name) {
    final palette = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEC4899), // Pink
      const Color(0xFFF97316), // Orange
    ];
    return palette[name.length % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _accentFor(category);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        category,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isListTile ? 9.5.sp : 8.5.sp,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Cart Badge
// ──────────────────────────────────────────────────────────────────────────────

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.quantity, required this.color});
  final double quantity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (quantity <= 0) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
      alignment: Alignment.center,
      child: Text(
        formatQuantity(quantity),
        style: TextStyle(
          color: Colors.white,
          fontSize: 8.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
