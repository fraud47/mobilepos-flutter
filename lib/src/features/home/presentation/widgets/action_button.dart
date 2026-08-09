import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.foregroundColor,
    required this.onPressed,
    this.height,
  });

  final String label;
  final Color color;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48.h,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foregroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.r)),
        ),
        child: Text(
          label,
          style: context.textTheme.titleMedium?.copyWith(
            color: foregroundColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
