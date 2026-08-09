import 'package:flutter/material.dart';

class ReceiptAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ReceiptAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      title: const Text(
        'Receipts',
        style: TextStyle(

          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}