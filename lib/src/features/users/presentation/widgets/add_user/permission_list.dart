import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/users/presentation/widgets/add_user/permission_card.dart';

import '../../screens/providers/add_user_controller.dart';

class _PermissionList extends ConsumerWidget {
  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final permissions =
        ref.watch(addUserControllerProvider).permissions;

    return Column(
      children: permissions
          .map(
            (permission) => PermissionCard(
          permission: permission,
        ),
      )
          .toList(),
    );
  }
}