import 'package:flutter/material.dart';
import 'customer_search_button.dart';


class CustomerAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: const BackButton(),
      title: const Text(
        "YOUR CUSTOMERS",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: const [
        CustomerSearchButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}