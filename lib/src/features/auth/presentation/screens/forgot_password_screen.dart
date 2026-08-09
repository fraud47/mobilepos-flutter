import 'package:mobilepos/src/features/auth/presentation/providers/session_provider.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

import '../providers/auth_provider.dart';

class ForgotPasswordScreen
    extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  ConsumerState<ForgotPasswordScreen>
  createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey =
  GlobalKey<FormState>();

  final _emailController =
  TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    // Validate form
    if (!(_formKey.currentState?.validate() ??
        false)) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Call the new SessionNotifier method
    final success = await ref
        .read(sessionProvider.notifier)
        .forgotPassword(
      email:
      _emailController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      // The API intentionally returns the same
      // response whether or not the email exists.
      //
      // Example:
      // "If that email exists, a reset link was sent"

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'If that email exists, a reset link was sent.',
          ),
        ),
      );

      // Return to login
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final sessionState =
    ref.watch(sessionProvider);

    final isLoading =
        sessionState.isLoading;

    final cs =
        context.theme.colorScheme;

    final tt =
        context.theme.textTheme;

    return Scaffold(
      appBar: const AppTopBar(
        title: '',
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            EdgeInsets.symmetric(
              horizontal:
              AppSpacing.lg.w,
            ),

            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [
                SizedBox(
                  height:
                  AppSpacing.xl.h,
                ),

                Text(
                  'auth.forgot_password_title'
                      .tr(),

                  textAlign:
                  TextAlign.center,

                  style: tt
                      .headlineMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height:
                  AppSpacing.sm.h,
                ),

                Text(
                  'auth.forgot_password_subtitle'
                      .tr(),

                  textAlign:
                  TextAlign.center,

                  style: tt.bodyMedium
                      ?.copyWith(
                    color:
                    cs.onSurfaceVariant,
                  ),
                ),

                SizedBox(
                  height:
                  AppSpacing.xxxl.h,
                ),

                Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      AppTextField(
                        controller:
                        _emailController,

                        enabled:
                        !isLoading,

                        keyboardType:
                        TextInputType
                            .emailAddress,

                        textInputAction:
                        TextInputAction
                            .done,

                        label:
                        'auth.email'.tr(),

                        hint:
                        'auth.email'.tr(),

                        prefixIcon:
                        const Icon(
                          Icons
                              .email_outlined,
                        ),

                        validator: (v) {
                          if (AppUtils
                              .isBlank(v)) {
                            return 'auth.email_required'
                                .tr();
                          }

                          if (!AppUtils
                              .isValidEmail(
                            v!.trim(),
                          )) {
                            return 'auth.email_invalid'
                                .tr();
                          }

                          return null;
                        },



                      ),

                      SizedBox(
                        height:
                        AppSpacing.lg.h,
                      ),

                      AppButton(
                        label:
                        'Send Reset Link',

                        isLoading:
                        isLoading,

                        onPressed:
                        isLoading
                            ? null
                            : _handleForgotPassword,

                        width:
                        ButtonSize.large,

                        isFullWidth:
                        false,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height:
                  AppSpacing.xxxl.h,
                ),

                TextButton(
                  onPressed:
                  isLoading
                      ? null
                      : () {
                    Navigator.of(
                      context,
                    ).pop();
                  },

                  child: Text(
                    'auth.back_to_login'
                        .tr(),

                    style: tt
                        .labelLarge
                        ?.copyWith(
                      color:
                      cs.primary,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                  height:
                  AppSpacing.xl.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}