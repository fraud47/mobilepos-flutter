import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/sidebar/drawer_header.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/sidebar/drawer_item.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/sidebar/section_title.dart';

import '../../../../../imports/core_imports.dart';
import '../../../../auth/presentation/widgets/logout_dialog.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Column(
          children: [
            const HeaderDrawer(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SectionTitle(title: 'Management'),
                  DrawerItem(
                    icon: FlutterRemix.store_fill,
                    title: 'Inventory Management',
                    onTap: () {
                      context.push(AppRoutes.inventoryManagement);
                    },
                  ),
                  DrawerItem(
                    icon: FlutterRemix.file_list_2_fill,
                    title: 'Receipts',
                    onTap: () =>context.push(AppRoutes.receiptManagement),
                  ),
                  DrawerItem(
                    icon: FlutterRemix.team_fill,
                    title: 'Customers Management',
                    onTap: () =>context.push(AppRoutes.customerManagement),
                  ),
                  DrawerItem(
                    icon: FlutterRemix.user_settings_fill,
                    title: 'Employee Management',
                    onTap: () =>context.push(AppRoutes.usersList),
                  ),
                  DrawerItem(
                    icon: FlutterRemix.building_2_fill,
                    title: 'Branches',
                    onTap: () =>context.push(AppRoutes.branchesManagement),
                  ),
                  Divider(height: 8.h, color: Colors.black12, thickness: 0.75),
                  DrawerItem(
                    icon: FlutterRemix.share_fill,
                    title: 'Refer App',
                    onTap: () {},
                  ),
                  DrawerItem(
                    icon: FlutterRemix.message_3_fill,
                    title: 'Help Chat',
                    onTap: () {},
                  ),
                  DrawerItem(
                    icon: FlutterRemix.shut_down_fill,
                    title: 'Log Out',
                    color: Colors.red,
                    onTap: () {
                      showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const LogoutDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
