import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

class CheckoutLink extends StatelessWidget {
  const CheckoutLink({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        foregroundColor: context.colors.primary,
      ),
      child: Text(
        label,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colors.primary,
          fontSize: 16.sp,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
