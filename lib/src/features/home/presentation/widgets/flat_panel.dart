import 'package:mobilepos/src/imports/core_imports.dart';
import 'home_constants.dart';

class FlatPanel extends StatelessWidget {
  const FlatPanel({
    super.key,
    required this.child,
    this.height,
    this.width,
  });

  final Widget child;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: HomeColors.panelBorder),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withValues(alpha: 0.12),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
