import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/branches/domain/entities/branch.dart';
import '../../../../branches/presentation/providers/branch_provider.dart';
import '../../screens/providers/add_user_controller.dart';

class BranchDropdown extends ConsumerWidget {
  const BranchDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);
    final branchId = ref.watch(addUserControllerProvider).branchId;
    final controller = ref.read(addUserControllerProvider.notifier);

    return branchesAsync.when(
      data: (branches) {
        if (branches.isEmpty) {
          return const Text('No branches available. Please create a branch first.');
        }

        // Initialize with first branch if null
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (branchId == null && branches.isNotEmpty) {
            controller.setBranchId(branches.first.id);
          }
        });

        return DropdownButtonFormField<int>(
          initialValue: branchId ?? branches.first.id,
          decoration: InputDecoration(
            labelText: 'Branch',
            prefixIcon: const Icon(FlutterRemix.store_2_line),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
          items: branches.map((Branch branch) {
            return DropdownMenuItem<int>(
              value: branch.id,
              child: Text(branch.name),
            );
          }).toList(),
          onChanged: (value) {
            controller.setBranchId(value);
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error loading branches: $err'),
    );
  }
}
