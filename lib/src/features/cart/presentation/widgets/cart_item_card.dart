import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/cart/presentation/widgets/placeholder_img.dart';
import 'package:mobilepos/src/features/cart/presentation/widgets/quality_control.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';

import '../../../../imports/core_imports.dart';
import '../../domain/models/cart_item_visual.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.visual,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  final CartItem item;
  final CartItemVisual visual;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final ValueChanged<double> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    final imageUrl = item.product.image.isNotEmpty
        ? item.product.image
        : visual.imageUrl;

    return Container(
      constraints: BoxConstraints(minHeight: 62.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(5.w),
            child:  SizedBox(
                width: 82.w,
                height: 82.h,
                child: const PlaceholderImg(),
              ),
            ),


          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4.w, 10.h, 8.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: onRemove,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Icon(
                            FlutterRemix.close_line,
                            color: Colors.red,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    visual.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF9A9A9A),
                      fontSize: 9.5.sp,
                      height: 1.15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${item.product.price.toStringAsFixed(2)}',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: cs.primary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      QuantityControl(
                        quantity: item.quantity,
                        onIncrement: onIncrement,
                        onDecrement: onDecrement,
                        onQuantityChanged: onQuantityChanged,
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