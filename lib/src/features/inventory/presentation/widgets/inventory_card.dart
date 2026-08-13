import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({
    super.key,
    required this.item,
    this.lowStockThreshold = 5,
  });

  final InventoryItem item;
  final int lowStockThreshold;

  Color _accentFor(String name) {
    if (name.isEmpty || name == 'Uncategorized') return const Color(0xFF6B7280);
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
    final catName = item.category ?? "Uncategorized";
    final catColor = _accentFor(catName);
    final itemColor = _accentFor(item.name);
    
    final isOut = item.stock <= 0;
    final isLow = !isOut && item.stock <= lowStockThreshold;
    
    final stockBg = isOut
        ? const Color(0xFFFEE2E2)
        : isLow
            ? const Color(0xFFFEF3C7)
            : const Color(0xFFDCFCE7);
            
    final stockFg = isOut
        ? const Color(0xFFDC2626)
        : isLow
            ? const Color(0xFFD97706)
            : const Color(0xFF15945B);

    final stockLabel = isOut
        ? 'Out of stock'
        : isLow
            ? 'Low: ${item.stock}'
            : '${item.stock} in stock';

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 4.h,
      ),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image or Color Initial Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: SizedBox(
              width: 58.w,
              height: 58.w,
              child: item.image.isNotEmpty
                  ? Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildInitialAvatar(itemColor),
                    )
                  : _buildInitialAvatar(itemColor),
            ),
          ),

          SizedBox(width: 12.w),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.sku != null && item.sku!.isNotEmpty
                      ? item.sku!
                      : "SKU: #${item.id ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    // Category Chip
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: catColor.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        catName,
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          color: catColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Price + Stock Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$${item.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                decoration: BoxDecoration(
                  color: stockBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  stockLabel,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w800,
                    color: stockFg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitialAvatar(Color color) {
    return ColoredBox(
      color: color.withValues(alpha: 0.12),
      child: Center(
        child: Text(
          item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ),
    );
  }
}
