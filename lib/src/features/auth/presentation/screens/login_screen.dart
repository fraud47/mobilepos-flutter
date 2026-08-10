import 'package:mobilepos/src/features/auth/presentation/providers/session_provider.dart' hide SessionStatus;
import 'package:mobilepos/src/features/auth/presentation/widgets/auth_entry_widgets.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _showSignInSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _SignInSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),

                    const AppLogo(),

                    SizedBox(height: 30.h),

                    Text(
                      'auth.log_in'.tr(),
                      textAlign: TextAlign.center,
                      style: tt.headlineMedium?.copyWith(
                        color: cs.onSurface,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Text(
                      'auth.log_in_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: tt.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: 16.sp,
                        height: 1.35,
                        letterSpacing: 0,
                      ),
                    ),

                    SizedBox(height: 120.h),

                    SocialAuthButton(
                      label: 'Continue with Google',
                      icon: SvgPicture.asset(
                        AppAssets.googleIcon,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    AuthPillButton(
                      label: 'Sign up',
                      onPressed: () {
                        context.push(AppRoutes.signup);
                      },
                    ),

                    SizedBox(height: 10.h),

                    AuthPillButton(
                      label: 'Sign in',
                      backgroundColor: cs.primaryContainer,
                      foregroundColor: cs.onPrimaryContainer,
                      onPressed: () {
                        _showSignInSheet(context);
                      },
                    ),

                    SizedBox(height: 10.h),

                    const AuthFinePrint(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignInSheet extends ConsumerStatefulWidget {
  const _SignInSheet();

  @override
  ConsumerState<_SignInSheet> createState() =>
      _SignInSheetState();
}

class _SignInSheetState
    extends ConsumerState<_SignInSheet> {
  final _formKey = GlobalKey<FormState>();

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    final errorMessage = await ref
        .read(sessionProvider.notifier)
        .login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      context.go(AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState =
    ref.watch(sessionProvider);

    final isLoading =
        sessionState.status ==
            SessionStatus.unknown;

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final bottomInset =
        MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 30.h,
        bottom: bottomInset + 18.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              Text(
                'auth.sign_in'.tr(),
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),

              Text(
                'auth.log_in_subtitle'.tr(),
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0,
                ),
              ),

              SizedBox(height: 20.h),

              AppTextField(
                controller: _emailController,
                enabled: !isLoading,
                label: 'auth.email'.tr(),
                keyboardType:
                TextInputType.emailAddress,
                textInputAction:
                TextInputAction.next,
                hint: 'auth.email'.tr(),
                underlined: true,
                validator: (v) {
                  if (AppUtils.isBlank(v)) {
                    return 'auth.email_required'.tr();
                  }

                  if (!AppUtils.isValidEmail(v!)) {
                    return 'auth.email_invalid'.tr();
                  }

                  return null;
                },
              ),

              SizedBox(
                height: AppSpacing.sm.h,
              ),

              AppTextField(
                controller: _passwordController,
                enabled: !isLoading,
                label: 'auth.password'.tr(),
                textInputAction:
                TextInputAction.done,
                hint: 'auth.password'.tr(),
                obscureText: _obscurePassword,
                underlined: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                    setState(() {
                      _obscurePassword =
                      !_obscurePassword;
                    });
                  },
                ),
                validator: (v) {
                  if (AppUtils.isBlank(v)) {
                    return 'auth.password_required'
                        .tr();
                  }

                  if (v!.length < 6) {
                    return 'auth.password_too_short'
                        .tr();
                  }

                  return null;
                },

              ),

              Align(
                alignment:
                Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    Navigator.pop(context);

                    context.push(
                      AppRoutes.forgotPassword,
                    );
                  },
                  child: Text(
                    'auth.forgot_password'.tr(),
                    style:
                    tt.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight:
                      FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              AuthPillButton(
                label: 'Sign in',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : _handleLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

