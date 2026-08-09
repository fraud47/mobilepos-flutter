import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/providers/add_user_controller.dart';

class StatusSwitch extends ConsumerWidget {
  const StatusSwitch({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final isActive =
        ref.watch(addUserControllerProvider).isActive;

    final controller =
    ref.read(addUserControllerProvider.notifier);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,

      // No border or outline
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),

      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        // No border or outline
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),

        secondary: Icon(
          isActive
              ? FlutterRemix.check_line
              : FlutterRemix.close_line,
          color: isActive
              ? Colors.green
              : Colors.red,
        ),

        title: const Text(
          'Account Status',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        subtitle: Text(
          isActive
              ? 'User can access the system'
              : 'User access is disabled',
        ),

        value: isActive,

        onChanged: controller.setActive,
      ),
    );
  }
}