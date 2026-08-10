import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/extensions/context_extension.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/reciepts/presentation/providers/reciept_provider.dart';

import '../widgets/reports/category_row.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF151515),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: _StatsGrid(),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: _SalesOverviewCard(),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: _SalesStatisticsCard(),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Recent Orders',
                  action: 'View All',
                  onTap: () {},
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: _RecentOrders(),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Top Selling Products',
                  action: 'Monthly',
                  onTap: () {},
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
              sliver: SliverToBoxAdapter(
                child: _TopSellingProducts(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HEADER
// -----------------------------------------------------------------------------

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
      child: Row(
        children: [
          _IconButton(
            icon: Icons.menu_rounded,
            onTap: () {},
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Havano POS',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF151515),
              ),
            ),
          ),
          _IconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {},
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            radius: 19.r,
            backgroundColor: const Color(0xFFE2E2E2),
            child: Icon(
              Icons.person_rounded,
              size: 22.sp,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SEARCH
// -----------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 21.sp,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Search products...',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Icon(
            Icons.tune_rounded,
            size: 20.sp,
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// QUICK ACTIONS
// -----------------------------------------------------------------------------

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.point_of_sale_rounded,
            title: 'New Sale',
            onTap: () {},
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _QuickAction(
            icon: Icons.inventory_2_outlined,
            title: 'Products',
            onTap: () {},
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _QuickAction(
            icon: Icons.receipt_long_outlined,
            title: 'Reports',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: Colors.black87,
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STATISTICS
// -----------------------------------------------------------------------------

class _StatsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAsync = ref.watch(receiptProvider);

    return receiptsAsync.when(
      data: (receipts) {
        final now = DateTime.now();
        final todayReceipts = receipts.where((r) => r.date.year == now.year && r.date.month == now.month && r.date.day == now.day).toList();
        
        final todaySales = todayReceipts.fold<double>(0.0, (sum, r) => sum + r.amount);
        final totalRevenue = receipts.fold<double>(0.0, (sum, r) => sum + r.amount);
        final productsSold = receipts.fold<int>(0, (sum, r) => sum + r.items);
        final transactions = receipts.length;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Today\'s Sales',
                    value: '\$${todaySales.toStringAsFixed(0)}',
                    change: '+0%',
                    isPositive: true,
                    icon: Icons.trending_up_rounded,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    title: 'Total Revenue',
                    value: '\$${totalRevenue.toStringAsFixed(0)}',
                    change: '+0%',
                    isPositive: true,
                    icon: Icons.attach_money_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Products Sold',
                    value: '$productsSold',
                    change: '0%',
                    isPositive: true,
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    title: 'Transactions',
                    value: '$transactions',
                    change: '0%',
                    isPositive: true,
                    icon: Icons.receipt_long_outlined,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('Error loading stats')),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 19.sp,
                color: Colors.black87,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          FittedBox(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF151515),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 7.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: isPositive
                  ? const Color(0xFFE2FFD0)
                  : const Color(0xFFFFE0DC),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              change,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
                color: isPositive
                    ? const Color(0xFF3C8B15)
                    : const Color(0xFFE14D3B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SALES OVERVIEW
// -----------------------------------------------------------------------------

class _SalesOverviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sales Overview',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Monthly sales performance',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              _DropdownButton(
                label: 'Monthly',
              ),
            ],
          ),
          SizedBox(height: 25.h),
          SizedBox(
            height: 170.h,
            child: _SalesChart(),
          ),
        ],
      ),
    );
  }
}

class _SalesChart extends ConsumerWidget {
  
  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final receiptsAsync = ref.watch(receiptProvider);

    return receiptsAsync.when(
      data: (receipts) {
        final now = DateTime.now();
        final monthlyTotals = List.filled(7, 0.0);
        final months = <String>[];
        
        for (int i = 6; i >= 0; i--) {
           int m = now.month - i;
           int y = now.year;
           while (m <= 0) {
             m += 12;
             y -= 1;
           }
           months.add(_monthName(m));
           
           final monthReceipts = receipts.where((r) => r.date.year == y && r.date.month == m);
           monthlyTotals[6 - i] = monthReceipts.fold<double>(0.0, (s, r) => s + r.amount);
        }
        
        final maxTotal = monthlyTotals.isEmpty ? 1.0 : monthlyTotals.reduce((a, b) => a > b ? a : b);
        final values = monthlyTotals.map((t) => (maxTotal > 0 ? t / maxTotal : 0.0).clamp(0.0, 1.0)).toList();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            values.length,
            (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: values[index] > 0 ? values[index] : 0.01,
                            child: Container(
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        months[index],
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('Error')),
    );
  }
}

// -----------------------------------------------------------------------------
// SALES STATISTICS
// -----------------------------------------------------------------------------

class _SalesStatisticsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final receiptsAsync = ref.watch(receiptProvider);
    
    return receiptsAsync.when(
      data: (receipts) {
        final totalSales = receipts.length;
        final totalRevenue = receipts.fold<double>(0.0, (s, r) => s + r.amount);

        return _DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sales Statistics',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _DropdownButton(label: 'Total'),
                ],
              ),
              SizedBox(height: 25.h),
              Row(
                children: [
                  SizedBox(
                    width: 145.w,
                    height: 145.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 145.w,
                          height: 145.w,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 22.w,
                            backgroundColor: const Color(0xFFE5E5E5),
                            valueColor: AlwaysStoppedAnimation(
                              cs.primary,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$totalSales',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Sales',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      children: [
                        CategoryRow(
                          title: 'Total Revenue',
                          value: '\$${totalRevenue.toStringAsFixed(0)}',
                          percentage: '100%',
                        ),
                        SizedBox(height: 14.h),
                        CategoryRow(
                          title: 'Transactions',
                          value: '$totalSales',
                          percentage: '100%',
                        ),
                        SizedBox(height: 14.h),
                        CategoryRow(
                          title: 'Avg. Order',
                          value: '\$${(totalSales > 0 ? totalRevenue / totalSales : 0).toStringAsFixed(0)}',
                          percentage: '100%',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('Error loading stats')),
    );
  }
}


// -----------------------------------------------------------------------------
// RECENT ORDERS
// -----------------------------------------------------------------------------

class _RecentOrders extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAsync = ref.watch(receiptProvider);

    return receiptsAsync.when(
      data: (receipts) {
        if (receipts.isEmpty) {
          return const Padding(padding: EdgeInsets.all(16.0), child: Text('No recent orders'));
        }

        final sorted = [...receipts]..sort((a, b) => b.date.compareTo(a.date));
        final recent = sorted.take(4).toList();

        return Column(
          children: recent.map((r) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _OrderCard(
                order: _OrderData(
                  id: '#${r.id}',
                  product: '${r.items} items',
                  date: '${r.date.day}/${r.date.month}/${r.date.year}',
                  payment: r.paymentMethod,
                  amount: '\$${r.amount.toStringAsFixed(2)}',
                  status: 'Complete',
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('Error loading orders')),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
  });

  final _OrderData order;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: EdgeInsets.all(13.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _StatusBadge(
                status: order.status,
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.more_horiz_rounded,
                size: 19.sp,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 20.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  order.product,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                order.amount,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                order.date,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              Text(
                order.payment,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderData {
  const _OrderData({
    required this.id,
    required this.product,
    required this.date,
    required this.payment,
    required this.amount,
    required this.status,
  });

  final String id;
  final String product;
  final String date;
  final String payment;
  final String amount;
  final String status;
}

// -----------------------------------------------------------------------------
// TOP SELLING PRODUCTS
// -----------------------------------------------------------------------------

class _TopSellingProducts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(homeProductsProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const _DashboardCard(child: Text('No products available'));
        }

        final sorted = [...products]..sort((a, b) => b.stock.compareTo(a.stock));
        final top = sorted.take(3).toList();

        return _DashboardCard(
          child: Column(
            children: top.asMap().entries.map((e) {
              final index = e.key;
              final p = e.value;
              return Column(
                children: [
                  if (index > 0) Divider(height: 24.h),
                  _ProductRow(
                    name: p.name,
                    category: 'Product',
                    price: '\$${p.price.toStringAsFixed(2)}',
                    sales: '${p.stock} in stock',
                    icon: Icons.inventory_2_outlined,
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('Error loading products')),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.name,
    required this.category,
    required this.price,
    required this.sales,
    required this.icon,
  });

  final String name;
  final String category;
  final String price;
  final String sales;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            size: 25.sp,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '$category • $sales',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// REUSABLE COMPONENTS
// -----------------------------------------------------------------------------

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                action,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DropdownButton extends StatelessWidget {
  const _DropdownButton({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.sp,
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          size: 21.sp,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final isComplete = status == 'Complete';
    final isWaiting = status == 'Waiting';

    final backgroundColor = isComplete
        ? const Color(0xFFE0F9ED)
        : isWaiting
        ? const Color(0xFFFFE8E2)
        : const Color(0xFFE3EDFF);

    final textColor = isComplete
        ? const Color(0xFF15945B)
        : isWaiting
        ? const Color(0xFFE25A3D)
        : const Color(0xFF3C72D9);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}