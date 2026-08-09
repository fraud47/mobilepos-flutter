import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../screens/providers/add_user_controller.dart';


class RoleDropdown extends ConsumerWidget {
  const RoleDropdown({
    super.key,
  });

  String _roleName(UserRole role) {
    switch (role) {
      case UserRole.administrator:
        return 'Administrator';

      case UserRole.manager:
        return 'Manager';

      case UserRole.cashier:
        return 'Cashier';

      case UserRole.custom:
        return 'Custom';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role =
        ref.watch(addUserControllerProvider).role;

    final controller =
    ref.read(addUserControllerProvider.notifier);

    return DropdownButtonFormField<UserRole>(
      initialValue: role,
      decoration:  InputDecoration(

        labelText: 'Role',
        prefixIcon: const Icon(FlutterRemix.shield_user_line),
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),borderSide: BorderSide.none),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),borderSide: BorderSide.none),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none,),),
      items: UserRole.values.map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(_roleName(role)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          controller.setRole(value);
        }
      },
    );
  }
}