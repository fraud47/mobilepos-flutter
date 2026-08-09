import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'header_action_box.dart';

class SearchActionRow extends StatelessWidget {
  const SearchActionRow({
    super.key,
    required this.showLightning,
    required this.onNewSale,
  });

  final bool showLightning;
  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 64.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                Icon(
                  FlutterRemix.search_line,
                  color: colorScheme.primary,
                  size: 28.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'I want to sell...',
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 19.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        HeaderActionBox(
          icon: FlutterRemix.barcode_box_line,
          onPressed: onNewSale,
        ),
        if (showLightning) ...[
          SizedBox(width: 8.w),
          HeaderActionBox(
            icon: FlutterRemix.flashlight_fill,
            onPressed: () {},
          ),
        ],
      ],
    );
  }
}
