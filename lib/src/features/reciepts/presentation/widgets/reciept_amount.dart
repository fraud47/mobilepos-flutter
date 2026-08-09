import 'package:flutter/material.dart';

class ReceiptAmount extends StatelessWidget {
  final double amount;

  const ReceiptAmount({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'ZWD${amount.toStringAsFixed(2)}',
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w800,

        fontSize: 16,
      ),
    );
  }
}