import 'package:flutter/material.dart';

class CustomerAvatar extends StatelessWidget {
  const CustomerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: const AssetImage(
        "assets/images/customer.png",
      ),
    );
  }
}