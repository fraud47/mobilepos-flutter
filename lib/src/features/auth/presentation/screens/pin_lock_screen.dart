import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilepos/src/features/auth/presentation/providers/auth_provider.dart';

class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  String _enteredPin = '';
  bool _hasError = false;

  void _onKeyPress(String digit) {
    if (_enteredPin.length < 4) {
      setState(() {
        _hasError = false;
        _enteredPin += digit;
      });

      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _hasError = false;
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  Future<void> _verifyPin() async {
    final success = await ref.read(sessionProvider.notifier).unlockWithPin(_enteredPin);
    if (!success && mounted) {
      setState(() {
        _hasError = true;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);
    final user = sessionState.user;
    final userEmail = user?.email ?? 'Cashier';
    final initial = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'C';

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              
              // Cashier Avatar
              CircleAvatar(
                radius: 36.r,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'POS Register Locked (Offline PIN)',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade400,
                ),
              ),

              SizedBox(height: 36.h),

              // PIN Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final filled = index < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _hasError
                          ? const Color(0xFFEF4444)
                          : filled
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white24,
                      border: Border.all(
                        color: _hasError
                            ? const Color(0xFFEF4444)
                            : filled
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white38,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),

              if (_hasError) ...[
                SizedBox(height: 12.h),
                Text(
                  'Incorrect PIN. Try default: 1234',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const Spacer(),

              // Numeric Keypad
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                children: [
                  ...List.generate(9, (index) {
                    final digit = '${index + 1}';
                    return _buildKeypadButton(digit, () => _onKeyPress(digit));
                  }),
                  const SizedBox.shrink(),
                  _buildKeypadButton('0', () => _onKeyPress('0')),
                  IconButton(
                    onPressed: _onDelete,
                    icon: Icon(Icons.backspace_outlined, color: Colors.white, size: 24.sp),
                  ),
                ],
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            digit,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
