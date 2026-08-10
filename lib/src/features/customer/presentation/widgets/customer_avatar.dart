import 'package:flutter/material.dart';

class CustomerAvatar extends StatelessWidget {
  const CustomerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundColor: Colors.grey.shade200,
      child: const Icon(
        Icons.person,
        size: 80,
        color: Colors.grey,
      ),
    );
  }
}