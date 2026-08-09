import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/providers/add_user_controller.dart';

class PermissionTile extends ConsumerWidget {
  final String module;
  final String title;
  final PermissionType type;
  final bool value;

  const PermissionTile({
    super.key,
    required this.module,
    required this.title,
    required this.type,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
    ref.read(addUserControllerProvider.notifier);

    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        controller.togglePermission(
          module: module,
          type: type,
          value: newValue,
        );
      },
    );
  }
}