import 'package:flutter/material.dart';

class PermissionChip extends StatelessWidget {
  final String role;

  const PermissionChip({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(

      label: Text(role,style: const TextStyle(
      color: Colors.black),),
      backgroundColor: Colors.grey.shade100,
    );
  }
}