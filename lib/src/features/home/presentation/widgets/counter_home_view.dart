import 'package:mobilepos/src/features/home/presentation/widgets/counter/dashboard_header.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/counter/recent_sales.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/counter/stat_grid.dart';
import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'inventory_header.dart';

class CounterHomeView extends StatelessWidget {
  const CounterHomeView({
    super.key,
    required this.onNewSale,
  });

  final VoidCallback onNewSale;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CounterDashboardHeader(),
          const CounterStatsGrid(),
          SizedBox(height: 24.h),
          const RecentSalesSection(),
          SizedBox(height: 24.h),
          const InventoryHeader(),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
