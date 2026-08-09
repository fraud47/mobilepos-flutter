import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'flat_panel.dart';
import 'home_constants.dart';
import 'home_models.dart';
import 'inventory_metric_tile.dart';
import 'score_ring.dart';

class InventoryHealthCard extends StatelessWidget {
  const InventoryHealthCard({super.key});

  static const List<InventoryMetric> _metrics = [
    InventoryMetric(
      value: '45',
      label: 'Incomplete',
      icon: FlutterRemix.error_warning_fill,
      color: Color(0xFFF4C63D),
    ),
    InventoryMetric(
      value: '0',
      label: 'Low stock',
      icon: FlutterRemix.archive_drawer_fill,
      color: Color(0xFFE96F4C),
    ),
    InventoryMetric(
      value: '0',
      label: 'Expired',
      icon: FlutterRemix.calendar_2_fill,
      color: Color(0xFFA64AC9),
    ),
    InventoryMetric(
      value: '45',
      label: 'In stock',
      icon: FlutterRemix.store_2_fill,
      color: Color(0xFF3FB34F),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlatPanel(
      child: Column(
        children: [
          SizedBox(height: 22.h),
          const ScoreRing(),
          SizedBox(height: 22.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Fix your inventory health for accurate reports.',
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colors.onSurface,
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          const Divider(height: 1, color: HomeColors.panelBorder),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _metrics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (context, index) {
              final metric = _metrics[index];
              return InventoryMetricTile(
                metric: metric,
                showRightBorder: index.isEven,
                showBottomBorder: index < 2,
              );
            },
          ),
        ],
      ),
    );
  }
}
