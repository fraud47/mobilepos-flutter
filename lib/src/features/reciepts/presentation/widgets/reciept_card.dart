import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/reciepts/presentation/widgets/reciept_amount.dart';
import 'package:mobilepos/src/features/reciepts/presentation/widgets/reciept_icon.dart';

import '../../domain/entities/reciept.dart';


class ReceiptCard extends StatelessWidget {
  final Receipt receipt;

  const ReceiptCard({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 30.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200) ),



      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [

            const ReceiptLeadingIcon(),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    receipt.id,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "by ${receipt.paymentMethod}",
                    style: const TextStyle(
                      fontSize: 12,

                    ),

                  ),

                  Text(
                    "${receipt.items} Items",
                    style:  TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600

                    ),
                  ),
                ],
              ),
            ),

            ReceiptAmount(
              amount: receipt.amount,
            )
          ],
        ),
      ),
    );
  }
}