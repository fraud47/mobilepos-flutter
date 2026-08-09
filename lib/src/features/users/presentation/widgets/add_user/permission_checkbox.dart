import 'package:flutter/material.dart';

class PermissionCheckBox extends StatelessWidget {

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const PermissionCheckBox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Checkbox(
          value: value,
          onChanged: onChanged,
        ),

        Text(title),
      ],
    );
  }
}