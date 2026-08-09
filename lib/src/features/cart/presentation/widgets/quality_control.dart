import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/extensions/context_extension.dart';

import 'quantity_editor_sheet.dart';
import 'small_circle_btn.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onQuantityChanged,
  });

  final double quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<double> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    void showQuantityEditor(BuildContext context) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        builder: (_) {
          return QuantityEditorSheet(
            initialQuantity: quantity,
            onSave: (value) {
              onQuantityChanged(value);
            },
          );
        },
      );
    }

    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmallCircleButton(
            icon: FlutterRemix.subtract_line,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: onDecrement,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(6.r),
            onTap: () => showQuantityEditor(context),
            child: SizedBox(
              width: 26.w,
              child: Text(
                formatQuantity(quantity),
                textAlign: TextAlign.center,
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SmallCircleButton(
            icon: FlutterRemix.add_line,
            backgroundColor: context.theme.colorScheme.primary,
            foregroundColor: Colors.white,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
