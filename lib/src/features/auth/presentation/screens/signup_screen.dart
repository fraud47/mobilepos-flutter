import 'package:mobilepos/src/features/auth/presentation/providers/session_provider.dart' hide SessionStatus;
import 'package:mobilepos/src/features/auth/presentation/widgets/auth_entry_widgets.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController =
  TextEditingController();

  final _tenantSlugController =
  TextEditingController();

  final _ownerDisplayNameController =
  TextEditingController();

  final _ownerEmailController =
  TextEditingController();

  final _ownerPasswordController =
  TextEditingController();

  final _confirmPasswordController =
  TextEditingController();

  int _currentStep = 0;

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  bool _rememberMe = true;

  @override
  void dispose() {
    _companyNameController.dispose();
    _tenantSlugController.dispose();
    _ownerDisplayNameController.dispose();
    _ownerEmailController.dispose();
    _ownerPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });

      return;
    }

    FocusScope.of(context).unfocus();

    final success = await ref
        .read(sessionProvider.notifier)
        .signUp(
      companyName:
      _companyNameController.text.trim(),
      tenantSlug:
      _tenantSlugController.text.trim(),
      ownerEmail:
      _ownerEmailController.text.trim(),
      ownerPassword:
      _ownerPasswordController.text,
      ownerDisplayName:
      _ownerDisplayNameController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (success) {
      // SessionNotifier updates the authentication
      // state after successful registration.
      //
      // If GoRouter is listening to sessionProvider,
      // it should automatically redirect the user.
    }
  }

  void _handleBack(bool isLoading) {
    if (isLoading) {
      return;
    }

    if (_currentStep == 0) {
      context.push(AppRoutes.login);
      return;
    }

    setState(() {
      _currentStep -= 1;
    });
  }

  String? _required(
      String? value,
      String message,
      ) {
    return AppUtils.isBlank(value)
        ? message
        : null;
  }

  String? _validateTenantSlug(
      String? value,
      ) {
    if (AppUtils.isBlank(value)) {
      return 'Tenant slug is required';
    }

    final slug = value!.trim();

    final isValid = RegExp(
      r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
    ).hasMatch(slug);

    if (!isValid) {
      return 'Use lowercase letters, numbers, and single hyphens';
    }

    return null;
  }

  String? _validateOwnerEmail(
      String? value,
      ) {
    if (AppUtils.isBlank(value)) {
      return 'auth.email_required'.tr();
    }

    if (!AppUtils.isValidEmail(
      value!.trim(),
    )) {
      return 'auth.email_invalid'.tr();
    }

    return null;
  }

  String? _validatePassword(
      String? value,
      ) {
    if (AppUtils.isBlank(value)) {
      return 'auth.password_required'.tr();
    }

    if (value!.length < 6) {
      return 'auth.password_too_short'.tr();
    }

    return null;
  }

  String? _validateConfirmPassword(
      String? value,
      ) {
    if (AppUtils.isBlank(value)) {
      return 'auth.confirm_password_required'.tr();
    }

    if (value !=
        _ownerPasswordController.text) {
      return 'auth.passwords_do_not_match'.tr();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final sessionState =
    ref.watch(sessionProvider);

    final isLoading =
        sessionState.status ==
            SessionStatus.unknown;

    final cs =
        context.theme.colorScheme;

    final tt =
        context.theme.textTheme;

    final stepTitle =
    switch (_currentStep) {
      0 => 'Business details',
      1 => 'Owner details',
      _ => 'Secure account',
    };

    final stepSubtitle =
    switch (_currentStep) {
      0 =>
      'Enter your company name and tenant URL slug.',
      1 =>
      'Add the owner information for this account.',
      _ =>
      'Create the password used to sign in.',
    };

    return Scaffold(
      backgroundColor: cs.surface,

      appBar: AppBar(
        backgroundColor: cs.primary,
        leading: IconButton(
          onPressed: isLoading
              ? null
              : () => _handleBack(
            isLoading,
          ),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: cs.onPrimary,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) {
            return SingleChildScrollView(
              padding:
              EdgeInsets.symmetric(
                horizontal: 24.w,
              ),

              child: ConstrainedBox(
                constraints:
                BoxConstraints(
                  minHeight:
                  constraints.maxHeight,
                ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,

                    children: [
                      SizedBox(
                        height: 16.h,
                      ),

                      Row(
                        children:
                        List.generate(
                          3,
                              (index) {
                            final active =
                                index <=
                                    _currentStep;

                            return Expanded(
                              child:
                              AnimatedContainer(
                                duration:
                                AppDurations
                                    .fast,

                                height: 5.h,

                                margin:
                                EdgeInsets
                                    .only(
                                  right:
                                  index == 2
                                      ? 0
                                      : 8.w,
                                ),

                                decoration:
                                BoxDecoration(
                                  color: active
                                      ? cs.primary
                                      : cs
                                      .outlineVariant
                                      .withValues(
                                    alpha:
                                    0.8,
                                  ),
                                  borderRadius:
                                  AppBorders
                                      .full,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: 18.h,
                      ),

                      Text(
                        'auth.create_account'
                            .tr(),

                        style: tt
                            .headlineMedium
                            ?.copyWith(
                          color:
                          cs.onSurface,
                          fontSize: 24.sp,
                          fontWeight:
                          FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),

                      SizedBox(
                        height: 6.h,
                      ),

                      Text(
                        stepSubtitle,
                        textAlign:
                        TextAlign.start,
                        style: tt.bodyLarge
                            ?.copyWith(
                          color:
                          cs.onSurfaceVariant,
                          fontSize: 16.sp,
                          height: 1.35,
                          letterSpacing: 0,
                        ),
                      ),

                      SizedBox(
                        height: 28.h,
                      ),

                      AnimatedSwitcher(
                        duration:
                        AppDurations
                            .fast,

                        child:
                        _SignupStepFields(
                          key: ValueKey(
                            _currentStep,
                          ),

                          currentStep:
                          _currentStep,

                          companyNameController:
                          _companyNameController,

                          tenantSlugController:
                          _tenantSlugController,

                          ownerDisplayNameController:
                          _ownerDisplayNameController,

                          ownerEmailController:
                          _ownerEmailController,

                          ownerPasswordController:
                          _ownerPasswordController,

                          confirmPasswordController:
                          _confirmPasswordController,

                          obscurePassword:
                          _obscurePassword,

                          obscureConfirmPassword:
                          _obscureConfirmPassword,

                          rememberMe:
                          _rememberMe,

                          isLoading:
                          isLoading,

                          onTogglePassword:
                              () {
                            setState(() {
                              _obscurePassword =
                              !_obscurePassword;
                            });
                          },

                          onToggleConfirmPassword:
                              () {
                            setState(() {
                              _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                            });
                          },

                          onRememberChanged:
                              (value) {
                            setState(() {
                              _rememberMe =
                                  value ?? false;
                            });
                          },

                          requiredValidator:
                          _required,

                          tenantSlugValidator:
                          _validateTenantSlug,

                          ownerEmailValidator:
                          _validateOwnerEmail,

                          passwordValidator:
                          _validatePassword,

                          confirmPasswordValidator:
                          _validateConfirmPassword,
                        ),
                      ),

                      SizedBox(
                        height: 40.h,
                      ),

                      AuthPillButton(
                        label:
                        _currentStep == 2
                            ? 'auth.sign_up'
                            .tr()
                            : 'Next',

                        isLoading:
                        isLoading,

                        onPressed:
                        isLoading
                            ? null
                            : _handleNext,
                      ),

                      SizedBox(
                        height: 24.h,
                      ),

                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          context.push(
                            AppRoutes.login,
                          );
                        },

                        child:
                        Text.rich(
                          TextSpan(
                            text:
                            'auth.already_have_account'
                                .tr(),

                            style: tt.bodyMedium
                                ?.copyWith(
                              color: cs
                                  .onSurfaceVariant,
                              letterSpacing: 0,
                            ),

                            children: [
                              TextSpan(
                                text:
                                'auth.sign_in'
                                    .tr(),

                                style:
                                TextStyle(
                                  color:
                                  cs.primary,
                                  fontWeight:
                                  FontWeight
                                      .w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 28.h,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignupStepFields
    extends StatelessWidget {
  const _SignupStepFields({
    super.key,
    required this.currentStep,
    required this.companyNameController,
    required this.tenantSlugController,
    required this.ownerDisplayNameController,
    required this.ownerEmailController,
    required this.ownerPasswordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.rememberMe,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onRememberChanged,
    required this.requiredValidator,
    required this.tenantSlugValidator,
    required this.ownerEmailValidator,
    required this.passwordValidator,
    required this.confirmPasswordValidator,
  });

  final int currentStep;

  final TextEditingController
  companyNameController;

  final TextEditingController
  tenantSlugController;

  final TextEditingController
  ownerDisplayNameController;

  final TextEditingController
  ownerEmailController;

  final TextEditingController
  ownerPasswordController;

  final TextEditingController
  confirmPasswordController;

  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool rememberMe;
  final bool isLoading;

  final VoidCallback
  onTogglePassword;

  final VoidCallback
  onToggleConfirmPassword;

  final ValueChanged<bool?>
  onRememberChanged;

  final String? Function(
      String? value,
      String message,
      ) requiredValidator;

  final String? Function(
      String? value,
      ) tenantSlugValidator;

  final String? Function(
      String? value,
      ) ownerEmailValidator;

  final String? Function(
      String? value,
      ) passwordValidator;

  final String? Function(
      String? value,
      ) confirmPasswordValidator;

  @override
  Widget build(
      BuildContext context,
      ) {
    return switch (currentStep) {
      0 => Column(
        children: [
          AppTextField(
            controller:
            companyNameController,
            enabled: !isLoading,
            label: 'Company name',
            textInputAction:
            TextInputAction.next,
            hint: 'Company name',
            underlined: true,
            validator: (value) =>
                requiredValidator(
                  value,
                  'Company name is required',
                ),
          ),

          SizedBox(height: 10.h),

          AppTextField(
            controller:
            tenantSlugController,
            enabled: !isLoading,
            label: 'Tenant Slug',
            textInputAction:
            TextInputAction.done,
            hint: 'Tenant slug',
            underlined: true,
            validator:
            tenantSlugValidator,
          ),
        ],
      ),

      1 => Column(
        children: [
          AppTextField(
            controller:
            ownerDisplayNameController,
            enabled: !isLoading,
            textInputAction:
            TextInputAction.next,
            hint: 'Owner display name',
            label: 'Owner display name',
            underlined: true,
            validator: (value) =>
                requiredValidator(
                  value,
                  'Owner display name is required',
                ),
          ),

          SizedBox(height: 10.h),

          AppTextField(
            controller:
            ownerEmailController,
            enabled: !isLoading,
            keyboardType:
            TextInputType.emailAddress,
            textInputAction:
            TextInputAction.done,
            hint: 'Owner email',
            label: 'Owner email',
            underlined: true,
            validator:
            ownerEmailValidator,
          ),
        ],
      ),

      _ => Column(
        children: [
          AppTextField(
            controller:
            ownerPasswordController,
            enabled: !isLoading,
            textInputAction:
            TextInputAction.next,
            hint: 'Owner password',
            label: 'Owner password',
            obscureText:
            obscurePassword,
            underlined: true,
            suffixIcon:
            IconButton(
              padding:
              EdgeInsets.zero,
              visualDensity:
              VisualDensity.compact,
              icon: Icon(
                obscurePassword
                    ? Icons
                    .visibility_off_outlined
                    : Icons
                    .visibility_outlined,
              ),
              onPressed:
              onTogglePassword,
            ),
            validator:
            passwordValidator,
          ),

          SizedBox(height: 24.h),

          AppTextField(
            controller:
            confirmPasswordController,
            enabled: !isLoading,
            textInputAction:
            TextInputAction.done,
            hint:
            'Confirm owner password',
            obscureText:
            obscureConfirmPassword,
            underlined: true,
            suffixIcon:
            IconButton(
              padding:
              EdgeInsets.zero,
              visualDensity:
              VisualDensity.compact,
              icon: Icon(
                obscureConfirmPassword
                    ? Icons
                    .visibility_off_outlined
                    : Icons
                    .visibility_outlined,
              ),
              onPressed:
              onToggleConfirmPassword,
            ),
            validator:
            confirmPasswordValidator,
          ),

          SizedBox(height: 24.h),

          Row(
            children: [
              SizedBox(
                width: 32.r,
                height: 32.r,
                child: Checkbox(
                  value: rememberMe,
                  activeColor:
                  context.theme
                      .colorScheme
                      .primary,
                  checkColor:
                  context.theme
                      .colorScheme
                      .onPrimary,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                      7.r,
                    ),
                  ),
                  side: BorderSide(
                    color: context
                        .theme
                        .colorScheme
                        .primary,
                    width: 1.5,
                  ),
                  onChanged: isLoading
                      ? null
                      : onRememberChanged,
                ),
              ),

              SizedBox(width: 10.w),

              Text(
                'auth.remember_me'
                    .tr(),
                style: context
                    .theme
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  color: context
                      .theme
                      .colorScheme
                      .onSurface,
                  fontSize: 16.sp,
                  fontWeight:
                  FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    };
  }
}