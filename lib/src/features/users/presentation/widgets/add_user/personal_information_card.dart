import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/providers/add_user_controller.dart';

class PersonalInformationCard extends ConsumerWidget {
  const PersonalInformationCard({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final controller =
    ref.read(addUserControllerProvider.notifier);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _UserTextField(
              label: 'Full Name',
              onChanged: controller.setFullName,
            ),
            SizedBox(height: 16.h),
            _UserTextField(
              label: 'Email Address',
              keyboard: TextInputType.emailAddress,
              onChanged: controller.setEmail,
            ),
            SizedBox(height: 16.h),
            _UserTextField(
              label: 'Phone Number',
              keyboard: TextInputType.phone,
              onChanged: controller.setPhone,
            ),
            SizedBox(height: 16.h),
            _UserTextField(
              label: 'Password',
              obscureText: true,
              onChanged: controller.setPassword,
            ),
            SizedBox(height: 16.h),
            _UserTextField(
              label: 'Confirm Password',
              obscureText: true,
              onChanged: controller.setConfirmPassword,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTextField extends StatelessWidget {
  final String label;
  final TextInputType keyboard;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const _UserTextField({
    required this.label,
    this.keyboard = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboard,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,

        filled: true,
        fillColor: Colors.grey.shade100,

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
    );
  }
}