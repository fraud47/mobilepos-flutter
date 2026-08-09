import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';
import '../widgets/add_user_fab.dart';
import '../widgets/sync_status_bar.dart';
import '../widgets/user_card.dart';
import '../widgets/users_app_bar.dart';
import '../widgets/users_filter_tab.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: const UsersAppBar(),

      body: Column(
        children: [
          const UsersTabBar (),
          const SyncStatusButton(),


          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              itemBuilder: (_, index) {
                return UserCard(user: users[index]);
              },
            ),
          ),
        ],
      ),

      floatingActionButton: const AddUserFAB(),
    );
  }
}