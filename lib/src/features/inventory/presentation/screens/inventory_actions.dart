import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/action_cards.dart';
import 'package:mobilepos/src/imports/core_imports.dart';

class InventoryActions {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.4,
                children: [
                  ActionCard(
                    title: "Add Item",
                    icon: FlutterRemix.add_box_line,
                    onTap: () => context.push(AppRoutes.inventoryPage),
                  ),
                  ActionCard(
                    title: "Add Category",
                    icon: FlutterRemix.apps_2_line,
                    onTap: () {},
                  ),
                  ActionCard(
                    title: "Add Modifier",
                    icon: FlutterRemix.price_tag_3_line,
                    onTap: () {},
                  ),
                  ActionCard(
                    title: "Bulk Edit",
                    icon: FlutterRemix.edit_box_line,
                    onTap: () {},
                  ), ActionCard(
                    title: 'Unit of Measure',
                    icon: FlutterRemix.ruler_line,
                    onTap:() => context.push(AppRoutes.unitOfMeasure),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
