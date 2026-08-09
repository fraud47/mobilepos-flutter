import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/inventory/presentation/screens/inventory_actions.dart';
import 'package:mobilepos/src/features/inventory/presentation/widgets/inventory_card.dart';


class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final products = [];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(FlutterRemix.arrow_left_line, color: colors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Inventory Management',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colors.primary,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search inventory',
                hintStyle: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  FlutterRemix.search_line,
                  color: Colors.grey.shade700,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return InventoryCard(item: products[index]);},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => InventoryActions.show(context),
        child: const Icon(FlutterRemix.add_box_line, color: Colors.black, size: 28),
      ),
    );
  }
}

class InventoryCategory extends StatelessWidget {
  final IconData icon;
  final String title;

  const InventoryCategory({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}
