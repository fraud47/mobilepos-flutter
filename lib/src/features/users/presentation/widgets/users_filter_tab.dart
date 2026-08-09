import 'package:flutter/material.dart';
import 'package:mobilepos/src/features/users/presentation/widgets/user_tab_item.dart';


class UsersTabBar extends StatelessWidget {
  const UsersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      color: Colors.white,
      child: const Row(
        children: [

          Expanded(
            child: UserTabItem(
              icon: Icons.people_alt_outlined,
              title: "All",
              selected: true,
            ),
          ),

          Expanded(
            child: UserTabItem(
              icon: Icons.verified_user_outlined,
              title: "Access",
            ),
          ),

          Expanded(
            child: UserTabItem(
              icon: Icons.access_time_outlined,
              title: "Attendance",
            ),
          ),

          Expanded(
            child: UserTabItem(
              icon: Icons.admin_panel_settings_outlined,
              title: "Admins",
            ),
          ),
        ],
      ),
    );
  }
}