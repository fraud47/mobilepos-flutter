import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import '../providers/branch_provider.dart';
import '../widgets/create_branch_dialog.dart';
import 'package:go_router/go_router.dart';

class BranchesScreen extends ConsumerWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesState = ref.watch(branchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
        leading: IconButton(
          icon: const Icon(FlutterRemix.arrow_left_line),
          onPressed: () => context.pop(),
        ),
      ),
      body: branchesState.when(
        data: (branches) {
          if (branches.isEmpty) {
            return const Center(
              child: Text(
                'No branches found.\nTap + to create one!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: branches.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final branch = branches[index];
              return ListTile(
                title: Text(branch.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Code: ${branch.code ?? 'N/A'}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                      ),
                      if (branch.address != null && branch.address!.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            Icon(FlutterRemix.map_pin_line, size: 13.sp, color: Colors.grey.shade500),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                branch.address!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: branch.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        branch.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: branch.isActive ? Colors.green : Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(FlutterRemix.edit_line, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CreateBranchDialog(initialBranch: branch),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(FlutterRemix.delete_bin_line, size: 20, color: Colors.red.shade400),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Branch'),
                            content: Text('Are you sure you want to delete ${branch.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          final success = await ref.read(createBranchControllerProvider.notifier).deleteBranch(branch.id);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Branch deleted')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateBranchDialog(),
          );
        },
        child: const Icon(FlutterRemix.add_line),
      ),
    );
  }
}
