import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/providers/add_user_controller.dart';


class PermissionPresets extends ConsumerWidget {
  const PermissionPresets({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final role =
        ref.watch(addUserControllerProvider).role;

    final controller =
    ref.read(addUserControllerProvider.notifier);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Permission Preset',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _PresetButton(
                title: 'Administrator',
                icon: Icons.admin_panel_settings,
                selected:
                role == UserRole.administrator,
                onTap: () {
                  controller.setRole(
                    UserRole.administrator,
                  );
                },
              ),

              _PresetButton(
                title: 'Manager',
                icon: Icons.manage_accounts,
                selected:
                role == UserRole.manager,
                onTap: () {
                  controller.setRole(
                    UserRole.manager,
                  );
                },
              ),

              _PresetButton(
                title: 'Cashier',
                icon: Icons.point_of_sale,
                selected:
                role == UserRole.cashier,
                onTap: () {
                  controller.setRole(
                    UserRole.cashier,
                  );
                },
              ),

              _PresetButton(
                title: 'Custom',
                icon: Icons.tune,
                selected:
                role == UserRole.custom,
                onTap: () {
                  controller.setRole(
                    UserRole.custom,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PresetButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
      ),
      child: ChoiceChip(
        avatar: Icon(
          icon,
          size: 18,
        ),
        label: Text(title),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}