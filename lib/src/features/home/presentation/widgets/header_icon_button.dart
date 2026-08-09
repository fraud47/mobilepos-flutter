import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isMenu = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isMenu;

  @override
  Widget build(BuildContext context) {
    final size = isMenu ? 32.w : 40.w;
    final iconSize = 20.sp;

    return !isMenu
        ? SizedBox.square(
            dimension: size,
            child: Material(
              color: context.colors.surfaceContainerHigh,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                onPressed: onPressed,
                padding: EdgeInsets.zero,
                splashRadius: size / 2,
                icon: Icon(
                  icon,
                  color: context.colors.onSecondaryContainer,
                  size: iconSize,
                ),
              ),
            ),
          )
        : IconButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            icon: Icon(icon, size: iconSize, color: context.colors.onSurface),
          );
  }
}
