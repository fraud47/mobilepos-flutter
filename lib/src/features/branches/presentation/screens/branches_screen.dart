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
                title: Text(branch.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Code: ${branch.code ?? 'N/A'}'),
                trailing: Container(
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
