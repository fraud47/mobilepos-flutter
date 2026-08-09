import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'flat_panel.dart';

class NewSaleCard extends StatelessWidget {
  const NewSaleCard({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return FlatPanel(
      height: 100.h,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                color: context.appColors.success,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FlutterRemix.add_line,
                color: context.appColors.onSuccess,
                size: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'NEW SALE',
              style: context.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
