import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';

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
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isListTile ? _listContent() : _gridContent(),
      ),
    );
  }

  Widget _gridContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductImage(
          imageUrl: item.image,
          cartQuantity: cartQuantity,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
          aspectRatio: 1.5,
        ),
        Padding(
          padding: EdgeInsets.all(5.w),
          child: _ProductDetails(
            item: item,
          ),
        ),
      ],
    );
  }

  Widget _listContent() {
    return SizedBox(
      height: 70.h,
      child: Row(
        children: [
          SizedBox(
            width: 112.w,
            height: double.infinity,
            child: _ProductImage(
              imageUrl: item.image,
              cartQuantity: cartQuantity,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(16.r),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: _ProductDetails(
                  item: item, maxNameLines: 2, quantity: cartQuantity),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.imageUrl,
    required this.cartQuantity,
    required this.borderRadius,
    this.aspectRatio,
  });

  final String imageUrl;
  final double cartQuantity;
  final BorderRadius borderRadius;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: borderRadius,
      child: _placeholder(),
    );

    final stack = Stack(
      children: [
        Positioned.fill(
          child: image,
        ),
        if (aspectRatio != null)
          Positioned(
            top: 8,
            right: 8,
            child: _BasketBadge(quantity: cartQuantity),
          ),
      ],
    );

    if (aspectRatio == null) {
      return stack;
    }

    return AspectRatio(
      aspectRatio: aspectRatio!,
      child: stack,
    );
  }

  Widget _placeholder() {
    return ColoredBox(
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _BasketBadge extends StatelessWidget {
  const _BasketBadge({
    required this.quantity,
  });

  final double quantity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.w,
      height: 28.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (quantity > 0)
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FlutterRemix.shopping_basket_line,
                  color: Colors.black87,
                  size: 15.sp,
                ),
              ),
            ),
          if (quantity > 0)
            Positioned(
              top: -6.h,
              right: -6.w,
              child: Badge(
                backgroundColor: Colors.redAccent,
                label: Text(formatQuantity(quantity)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    required this.item,
    this.quantity,
    this.maxNameLines = 1,
  });

  final InventoryItem item;
  final int maxNameLines;
  final double? quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                maxLines: maxNameLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (quantity != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BasketBadge(quantity: quantity ?? 0),
              )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 11.sp,
                ),
              ),
            ),
            Text(
              '${item.stock}',
              style: TextStyle(
                fontSize: 9.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
