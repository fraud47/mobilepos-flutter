import 'package:flutter/material.dart';

import 'customer_avatar.dart';

class EmptyCustomerView extends StatelessWidget {
  const EmptyCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const CustomerAvatar(),

            const SizedBox(height: 25),

            Text(
              "Looks like you don't have any customers\nyet. Add some to get started!",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}