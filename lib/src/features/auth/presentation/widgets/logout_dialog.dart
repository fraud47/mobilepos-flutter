import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/auth/presentation/providers/session_provider.dart';

import '../providers/auth_provider.dart';

class LogoutDialog extends ConsumerStatefulWidget {
  const LogoutDialog({
    super.key,
  });

  @override
  ConsumerState<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends ConsumerState<LogoutDialog> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await ref.read(sessionProvider.notifier).logout();

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoggingOut = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to log out. Please try again.',
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                24.w,
                24.h,
                24.w,
                20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 58.w,
                        height: 58.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FlutterRemix.logout_box_r_line,
                          color: const Color(0xFFD84040),
                          size: 28.sp,
                        ),
                      ),

                      // Close button
                      InkWell(
                        onTap: _isLoggingOut
                            ? null
                            : () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(6.r),
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: const Color(0xFFE5E5E5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            FlutterRemix.close_line,
                            size: 22.sp,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Title
                  Text(
                    'You are about to log out',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF182033),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Description
                  Text(
                    'Are you sure you want to log out of your account? '
                        'You will need to sign in again to access your account.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action area
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  // Cancel
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: OutlinedButton.icon(
                        onPressed: _isLoggingOut
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: Icon(
                          FlutterRemix.close_line,
                          size: 18.sp,
                        ),
                        label: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF555555),
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFFE1E1E1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Logout
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton.icon(
                        onPressed: _isLoggingOut ? null : _logout,
                        icon: _isLoggingOut
                            ? SizedBox(
                          width: 17.w,
                          height: 17.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Icon(
                          FlutterRemix.logout_box_r_line,
                          size: 18.sp,
                        ),
                        label: Text(
                          _isLoggingOut ? 'Logging out...' : 'Logout',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFD84040),
                          disabledBackgroundColor:
                          const Color(0xFFD84040).withValues(
                            alpha: 0.7,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                    ),
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