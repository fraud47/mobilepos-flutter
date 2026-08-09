import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../extensions/context_extension.dart';

class CategoryRow extends StatelessWidget {

  const CategoryRow({
    required this.title,
    required this.value,
    required this.percentage,
  });

  final String title;
  final String value;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration:  BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primary,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          percentage,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
