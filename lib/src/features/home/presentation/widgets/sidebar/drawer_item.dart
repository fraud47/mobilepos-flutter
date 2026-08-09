import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;
  final VoidCallback onTap;
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurface,
        size: 20.sp,
      ),
      title: Text(title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
          )),
      trailing: count != null
          ? CircleAvatar(
              radius: 15.r,
              backgroundColor: Colors.white,
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11.sp,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
    ;
  }
}
