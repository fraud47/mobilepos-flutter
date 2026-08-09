import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/users/presentation/screens/providers/add_user_controller.dart';
import '../widgets/add_user/permission_card.dart';
import '../widgets/add_user/permission_presets.dart';
import '../widgets/add_user/personal_information_card.dart';
import '../widgets/add_user/role_dropdown.dart';
import '../widgets/add_user/save_button.dart';
import '../widgets/add_user/status_switch.dart';

final addUserControllerProvider =
NotifierProvider<AddUserController, AddUserState>(
  AddUserController.new,
);
class AddUserScreen extends StatelessWidget {
  const AddUserScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: const BackButton(

        ),
        title: const Text(
          'Add User',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              const PersonalInformationCard(),
              const SizedBox(height: 24),

              const Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const RoleDropdown(),
              const SizedBox(height: 12),
              const StatusSwitch(),
              const SizedBox(height: 20),
              const Text(
                'Module Permissions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _PermissionList(),
              const SizedBox(height: 16),
              const SaveButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

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