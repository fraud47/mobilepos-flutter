import 'package:flutter/material.dart';
import 'package:mobilepos/src/features/users/presentation/widgets/add_user/permission_checkbox.dart';
import '../../../domain/models/module_permission.dart';

class PermissionRow extends StatelessWidget {
  final ModulePermission permission;

  const PermissionRow({
    super.key,
    required this.permission,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              permission.module,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                PermissionCheckBox(
                  title: "View",
                  value: permission.view,
                  onChanged: (v) {},
                ),

                PermissionCheckBox(
                  title: "Create",
                  value: permission.create,
                  onChanged: (v) {},
                ),

                PermissionCheckBox(
                  title: "Edit",
                  value: permission.update,
                  onChanged: (v) {},
                ),

                PermissionCheckBox(
                  title: "Delete",
                  value: permission.delete,
                  onChanged: (v) {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}