import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today,size:12),
            label: const Text("Attendance"),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: const StadiumBorder(),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.receipt_long,size:12),
            label: const Text("Pay Slip"),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }
}