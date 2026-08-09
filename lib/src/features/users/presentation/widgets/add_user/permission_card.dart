import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/providers/add_user_controller.dart';
import 'permission_header.dart';
import 'permission_tile.dart';

class PermissionCard extends ConsumerWidget {
  final PermissionState permission;

  const PermissionCard({
    super.key,
    required this.permission,
  });

  IconData _getIcon(String module) {
    switch (module) {
      case 'Inventory':
        return Icons.inventory_2_outlined;

      case 'Customers':
        return Icons.people_outline;

      case 'Sales':
        return Icons.point_of_sale_outlined;

      case 'Employee Management':
        return Icons.manage_accounts_outlined;

      case 'Reports':
        return Icons.bar_chart_outlined;

      case 'Settings':
        return Icons.settings_outlined;

      default:
        return Icons.security_outlined;
    }
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PermissionHeader(
              title: permission.module,
              icon: _getIcon(
                permission.module,
              ),
            ),

            const Divider(
              height: 28,
            ),

            PermissionTile(
              module: permission.module,
              title: 'View',
              type: PermissionType.view,
              value: permission.view,
            ),

            PermissionTile(
              module: permission.module,
              title: 'Create',
              type: PermissionType.create,
              value: permission.create,
            ),

            PermissionTile(
              module: permission.module,
              title: 'Update',
              type: PermissionType.update,
              value: permission.update,
            ),

            PermissionTile(
              module: permission.module,
              title: 'Delete',
              type: PermissionType.delete,
              value: permission.delete,
            ),
          ],
        ),
      ),
    );
  }
}