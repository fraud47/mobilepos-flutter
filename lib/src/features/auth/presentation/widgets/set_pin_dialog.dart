import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/auth/presentation/providers/auth_provider.dart';

class SetPinDialog extends ConsumerStatefulWidget {
  const SetPinDialog({super.key});

  @override
  ConsumerState<SetPinDialog> createState() => _SetPinDialogState();
}

class _SetPinDialogState extends ConsumerState<SetPinDialog> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _savePin() async {
    if (!_formKey.currentState!.validate()) return;

    final pin = _pinController.text.trim();
    await ref.read(sessionProvider.notifier).setOfflinePin(pin);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Offline PIN updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: const Text('Set Offline Cashier PIN'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set a 4-digit PIN to quickly lock & unlock your POS register when offline.',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.sp, letterSpacing: 8, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '••••',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              validator: (value) {
                if (value == null || value.length != 4 || int.tryParse(value) == null) {
                  return 'PIN must be exactly 4 digits';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _savePin,
          child: const Text('Save PIN'),
        ),
      ],
    );
  }
}
