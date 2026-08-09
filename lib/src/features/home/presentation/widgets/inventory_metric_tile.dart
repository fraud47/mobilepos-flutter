import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'home_constants.dart';
import 'home_models.dart';

class InventoryMetricTile extends StatelessWidget {
  const InventoryMetricTile({
    super.key,
    required this.metric,
    required this.showRightBorder,
    required this.showBottomBorder,
  });

  final InventoryMetric metric;
  final bool showRightBorder;
  final bool showBottomBorder;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: showRightBorder
              ? const BorderSide(color: HomeColors.panelBorder)
              : BorderSide.none,
          bottom: showBottomBorder
              ? const BorderSide(color: HomeColors.panelBorder)
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(metric.icon, color: metric.color, size: 24.sp),
          ),
          SizedBox(height: 14.h),
          Text(
            metric.value,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colors.onSurface,
              fontSize: 23.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            metric.label,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
