import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import '../providers/branch_provider.dart';
import 'package:go_router/go_router.dart';

class CreateBranchDialog extends ConsumerStatefulWidget {
  const CreateBranchDialog({super.key});

  @override
  ConsumerState<CreateBranchDialog> createState() => _CreateBranchDialogState();
}

class _CreateBranchDialogState extends ConsumerState<CreateBranchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(createBranchControllerProvider.notifier).createBranch(
      _nameController.text.trim(),
      _codeController.text.trim().isEmpty ? null : _codeController.text.trim(),
    );

    if (success && mounted) {
      context.pop(); // Close dialog on success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Branch created successfully!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final createBranchState = ref.watch(createBranchControllerProvider);
    final isLoading = createBranchState.isLoading;

    ref.listen<AsyncValue<void>>(
      createBranchControllerProvider,
      (_, state) {
        if (state.hasError && !state.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create New Branch',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Branch Name *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Name is required' : null,
                enabled: !isLoading,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Branch Code (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                enabled: !isLoading,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isLoading ? null : () => context.pop(),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: isLoading
                        ? SizedBox(height: 16.h, width: 16.h, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Create'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
