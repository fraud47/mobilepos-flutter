import 'package:flutter/material.dart';
import 'package:mobilepos/src/features/reciepts/presentation/widgets/reciept_card.dart';

import '../../domain/entities/reciept.dart';

class ReceiptList extends StatelessWidget {
  final List<Receipt> receipts;

  const ReceiptList({
    super.key,
    required this.receipts,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: receipts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return ReceiptCard(
          receipt: receipts[index],
        );
      },
    );
  }
}