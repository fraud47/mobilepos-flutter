import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final BoxFit fit;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;

  const AppLogo({
    super.key,
    this.size = 250,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = Image.asset(
      'assets/images/splash.png',
      width: size,
      height: size,
      fit: fit,
    );

    if (borderRadius != null) {
      logo = ClipRRect(
        borderRadius: borderRadius!,
        child: logo,
      );
    }

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: logo,
    );
  }
}

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: OutlinedButton(
        onPressed: onPressed ?? () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: cs.surface,
          foregroundColor: cs.onSurface,
          side: BorderSide(color: cs.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: AppBorders.lg),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox.square(
                dimension: 26.w,
                child: Center(child: icon),
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: tt.titleSmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthPillButton extends StatelessWidget {
  const AuthPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final disabled = onPressed == null || isLoading;
    final effectiveBackgroundColor = backgroundColor ?? cs.primary;
    final effectiveForegroundColor = foregroundColor ?? cs.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: TextButton(
        onPressed: disabled ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          disabledBackgroundColor:
              effectiveBackgroundColor.withValues(alpha: 0.55),
          disabledForegroundColor:
              effectiveForegroundColor.withValues(alpha: 0.8),
          shape: const RoundedRectangleBorder(borderRadius: AppBorders.lg),
        ),
        child: AnimatedSwitcher(
          duration: AppDurations.fast,
          child: isLoading
              ? SizedBox.square(
                  key: const ValueKey('loader'),
                  dimension: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: effectiveForegroundColor,
                  ),
                )
              : Text(
                  key: const ValueKey('label'),
                  label,
                  style: TextStyle(
                    color: effectiveForegroundColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
        ),
      ),
    );
  }
}

class AuthFinePrint extends StatelessWidget {
  const AuthFinePrint({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Privacy Policy   .   Terms of Service',
      textAlign: TextAlign.center,
      style: context.theme.textTheme.bodySmall?.copyWith(
        color: context.theme.colorScheme.onSurfaceVariant,
        fontSize: 13.sp,
        letterSpacing: 0,
      ),
    );
  }
}
