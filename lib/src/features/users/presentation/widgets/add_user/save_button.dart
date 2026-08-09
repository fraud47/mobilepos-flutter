import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/providers/add_user_controller.dart';


class SaveButton extends ConsumerWidget {
  const SaveButton({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final isSaving =
        ref.watch(addUserControllerProvider).isSaving;

    final controller =
    ref.read(addUserControllerProvider.notifier);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: isSaving
            ? null
            : () async {
          final success =
          await controller.saveUser();

          if (!context.mounted) {
            return;
          }

          if (success) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'User created successfully',
                ),
              ),
            );

            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Please complete all required fields',
                ),
              ),
            );
          }
        },
        icon: isSaving
            ? const SizedBox(
          width: 20,
          height: 20,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : const Icon(
          Icons.save_outlined,
        ),
        label: Text(
          isSaving
              ? 'Saving...'
              : 'Save User',
        ),
      ),
    );
  }
}