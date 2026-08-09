import 'dart:math';

import 'package:flutter/material.dart';

class AddCustomerFAB extends StatelessWidget {
  const AddCustomerFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.white,
      shape:CircleBorder(),
      onPressed: () {},

      child: const Icon(Icons.person_add_alt_1),
    );
  }
}