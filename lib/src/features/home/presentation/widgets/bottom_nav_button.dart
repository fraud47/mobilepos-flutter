import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'home_models.dart';

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    super.key,
    required this.item,
    required this.selected,
    required this.badgeCount,
    required this.onPressed,
  });

  final BottomNavItem item;
  final bool selected;
  final int badgeCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final color = selected ? colorScheme.primary : Colors.grey[500];

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: Size.zero,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 16.h,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Icon(item.icon, size: 18.sp,fontWeight: FontWeight.w100,),
                if (badgeCount > 0)
                  Positioned(
                    top: -5.h,
                    right: -11.w,
                    child: Badge(
                      label: Text('$badgeCount'),
                      backgroundColor: context.appColors.primary,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
