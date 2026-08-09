import 'package:flutter/material.dart';

import 'date_box.dart';

class ReceiptDateFilter extends StatelessWidget {
  const ReceiptDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          Expanded(
            child: DateBox(
              title: 'From',
              date: '16 May 2026',
            ),
          ),

          Expanded(
            child: DateBox(
              title: 'To',
              date: '18 May 2026',
            ),
          ),
        ],
      ),
    );
  }
}