import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobilepos/src/extensions/context_extension.dart';
import 'package:mobilepos/src/features/home/presentation/providers/reports_provider.dart';
import 'package:mobilepos/src/features/reciepts/presentation/providers/reciept_provider.dart';
import 'package:mobilepos/src/features/reciepts/domain/entities/reciept.dart';

import '../widgets/reports/category_row.dart';

// ──────────────────────────────────────────────────────────────────────────────
// REPORTS PAGE
// ──────────────────────────────────────────────────────────────────────────────

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final period = ref.watch(reportPeriodProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(salesSummaryProvider);
          ref.invalidate(salesByProductProvider);
          ref.invalidate(purchaseSummaryProvider);
          ref.invalidate(receiptProvider);
        },
        child: SafeArea(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ── Header ──────────────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reports',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF151515),
                              ),
                            ),
                            Text(
                              DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Period Toggle ────────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                sliver: SliverToBoxAdapter(child: _PeriodToggle()),
              ),

              // ── Today's Quick Stats (only in Today mode) ─────────────────────
              if (period == ReportPeriod.today)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(child: _TodayQuickStats()),
                ),

              // ── POS Sales section ────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionLabel(
                    icon: FlutterRemix.shopping_bag_2_fill,
                    label: 'POS Sales',
                    color: cs.primary,
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                sliver: SliverToBoxAdapter(child: _SalesSummaryCard()),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                sliver: SliverToBoxAdapter(child: _SalesBarChart()),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                sliver: SliverToBoxAdapter(child: _TopProductsCard()),
              ),

              // ── Expenses / Purchases section ─────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionLabel(
                    icon: FlutterRemix.wallet_3_fill,
                    label: 'Expenses & Purchases',
                    color: const Color(0xFFE07B2A),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 36.h),
                sliver: SliverToBoxAdapter(child: _ExpensesCard()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// PERIOD TOGGLE
// ──────────────────────────────────────────────────────────────────────────────

class _PeriodToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(reportPeriodProvider);
    final notifier = ref.read(reportPeriodProvider.notifier);
    final cs = context.theme.colorScheme;

    return Container(
      height: 46.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: ReportPeriod.values.map((p) {
          final isSelected = p == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => notifier.select(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  p.label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// TODAY QUICK STATS — hourly transaction count from receipts
// ──────────────────────────────────────────────────────────────────────────────

class _TodayQuickStats extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAsync = ref.watch(receiptProvider);

    return receiptsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (receipts) {
        final now = DateTime.now();
        final today = receipts.where((r) =>
            r.date.year == now.year &&
            r.date.month == now.month &&
            r.date.day == now.day).toList();

        final todayCount = today.length;
        final todayRevenue = today.fold(0.0, (s, r) => s + r.amount);
        final todayAvg = todayCount > 0 ? todayRevenue / todayCount : 0.0;

        final lastHour = today.where((r) =>
            r.date.isAfter(now.subtract(const Duration(hours: 1)))).length;

        return Row(
          children: [
            Expanded(
              child: _QuickStatCard(
                icon: FlutterRemix.bill_line,
                label: 'Sales Today',
                value: '$todayCount',
                sub: '$lastHour in last hour',
                color: const Color(0xFF6C63FF),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _QuickStatCard(
                icon: FlutterRemix.money_dollar_circle_fill,
                label: 'Revenue Today',
                value: NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0)
                    .format(todayRevenue),
                sub: 'avg \$${todayAvg.toStringAsFixed(2)}/sale',
                color: const Color(0xFF15945B),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF151515),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            sub,
            style: TextStyle(fontSize: 9.5.sp, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ──────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF151515),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SALES SUMMARY CARD
// ──────────────────────────────────────────────────────────────────────────────

class _SalesSummaryCard extends ConsumerWidget {
  static final _currency = NumberFormat.simpleCurrency(decimalDigits: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final salesAsync = ref.watch(salesSummaryProvider);
    final period = ref.watch(reportPeriodProvider);

    return _Card(
      child: salesAsync.when(
        loading: () => SizedBox(
          height: 80.h,
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => _ErrorTile(message: e.toString()),
        data: (sales) {
          final avg = sales.invoiceCount > 0
              ? sales.grandTotal / sales.invoiceCount
              : 0.0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(title: 'Sales Summary', subtitle: period.label),
              SizedBox(height: 16.h),
              if (sales.invoiceCount == 0)
                _EmptyDataWidget(
                  message: 'No sales recorded for ${period.label.toLowerCase()}',
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        label: 'Total Revenue',
                        value: _currency.format(sales.grandTotal),
                        icon: Icons.attach_money_rounded,
                        iconColor: cs.primary,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _MetricTile(
                        label: 'Transactions',
                        value: '${sales.invoiceCount}',
                        icon: Icons.receipt_long_outlined,
                        iconColor: const Color(0xFF6C63FF),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _MetricTile(
                        label: 'Avg. Order',
                        value: _currency.format(avg),
                        icon: Icons.calculate_outlined,
                        iconColor: const Color(0xFF2ABFA3),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SALES BAR CHART — driven by local receipts grouped by period
// ──────────────────────────────────────────────────────────────────────────────

class _SalesBarChart extends ConsumerWidget {
  static final _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final receiptsAsync = ref.watch(allReceiptsProvider);
    final period = ref.watch(reportPeriodProvider);

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(title: 'Sales Overview', subtitle: period.label),
          SizedBox(height: 16.h),
          receiptsAsync.when(
            loading: () => SizedBox(
              height: 120.h,
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => _ErrorTile(message: e.toString()),
            data: (receipts) {
              final now = DateTime.now();

              late List<String> labels;
              late List<double> values;
              late List<int> counts;

              switch (period) {
                case ReportPeriod.today:
                  // 3-hour buckets 00:00–23:59
                  labels = List.generate(
                    8, (i) => '${(i * 3).toString().padLeft(2, '0')}h');
                  values = List.generate(8, (bucket) {
                    final hour = bucket * 3;
                    return receipts
                        .where((r) =>
                            r.date.year == now.year &&
                            r.date.month == now.month &&
                            r.date.day == now.day &&
                            r.date.hour >= hour &&
                            r.date.hour < hour + 3)
                        .fold(0.0, (s, r) => s + r.amount);
                  });
                  counts = List.generate(8, (bucket) {
                    final hour = bucket * 3;
                    return receipts
                        .where((r) =>
                            r.date.year == now.year &&
                            r.date.month == now.month &&
                            r.date.day == now.day &&
                            r.date.hour >= hour &&
                            r.date.hour < hour + 3)
                        .length;
                  });

                case ReportPeriod.month:
                  // Daily buckets for each day of the current month
                  final daysInMonth =
                      DateTime(now.year, now.month + 1, 0).day;
                  // Show every 5th day as label for readability
                  labels = List.generate(daysInMonth, (i) {
                    final day = i + 1;
                    return (day == 1 || day % 7 == 0 || day == daysInMonth)
                        ? '$day'
                        : '';
                  });
                  values = List.generate(daysInMonth, (i) {
                    return receipts
                        .where((r) =>
                            r.date.year == now.year &&
                            r.date.month == now.month &&
                            r.date.day == i + 1)
                        .fold(0.0, (s, r) => s + r.amount);
                  });
                  counts = List.generate(daysInMonth, (i) {
                    return receipts
                        .where((r) =>
                            r.date.year == now.year &&
                            r.date.month == now.month &&
                            r.date.day == i + 1)
                        .length;
                  });

                case ReportPeriod.year:
                  labels = _months;
                  values = List.generate(12, (m) {
                    return receipts
                        .where((r) =>
                            r.date.year == now.year && r.date.month == m + 1)
                        .fold(0.0, (s, r) => s + r.amount);
                  });
                  counts = List.generate(12, (m) {
                    return receipts
                        .where((r) =>
                            r.date.year == now.year && r.date.month == m + 1)
                        .length;
                  });
              }

              final maxVal = values.isEmpty
                  ? 1.0
                  : values.reduce((a, b) => a > b ? a : b);
              final totalSales = counts.fold(0, (s, c) => s + c);

              if (totalSales == 0) {
                return _EmptyDataWidget(
                  message: 'No sales data for ${period.label.toLowerCase()}',
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary row above chart
                  Row(
                    children: [
                      Text(
                        '$totalSales sale${totalSales != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                        ),
                      ),
                      Text(
                        ' for ${period.label.toLowerCase()}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Bar chart
                  SizedBox(
                    height: 130.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(values.length, (i) {
                        final ratio = maxVal > 0
                            ? (values[i] / maxVal).clamp(0.01, 1.0)
                            : 0.01;
                        final hasData = values[i] > 0;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Transaction count tooltip above bar
                                if (hasData && counts[i] > 0)
                                  Text(
                                    '${counts[i]}',
                                    style: TextStyle(
                                      fontSize: 6.5.sp,
                                      color: cs.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                SizedBox(height: 2.h),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FractionallySizedBox(
                                      heightFactor: hasData ? ratio : 0.02,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              cs.primary,
                                              cs.primary.withValues(alpha: 0.55),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(5.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                if (labels[i].isNotEmpty)
                                  Text(
                                    labels[i],
                                    style: TextStyle(
                                      fontSize: 7.5.sp,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                else
                                  SizedBox(height: 9.h),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// TOP PRODUCTS CARD
// ──────────────────────────────────────────────────────────────────────────────

class _TopProductsCard extends ConsumerWidget {
  static final _currency = NumberFormat.simpleCurrency(decimalDigits: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final productsAsync = ref.watch(salesByProductProvider);
    final period = ref.watch(reportPeriodProvider);

    return _Card(
      child: productsAsync.when(
        loading: () => SizedBox(
          height: 80.h,
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => _ErrorTile(message: e.toString()),
        data: (products) {
          final top = products.take(5).toList();
          final totalRevenue = products.fold(0.0, (s, p) => s + p.total);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(
                title: 'Top Products',
                subtitle: period.label,
              ),
              SizedBox(height: 14.h),
              if (top.isEmpty)
                _EmptyDataWidget(
                  message: 'No product sales for ${period.label.toLowerCase()}',
                )
              else
                ...top.asMap().entries.map((e) {
                  final p = e.value;
                  final pct = totalRevenue > 0 ? p.total / totalRevenue : 0.0;
                  final rankColors = [
                    const Color(0xFFFFD700), // Gold
                    const Color(0xFFC0C0C0), // Silver
                    const Color(0xFFCD7F32), // Bronze
                    cs.primary.withValues(alpha: 0.6),
                    cs.primary.withValues(alpha: 0.4),
                  ];
                  final rankColor = rankColors[e.key.clamp(0, 4)];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 26.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                color: rankColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${e.key + 1}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w800,
                                  color: rankColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                p.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _currency.format(p.total),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '${p.qty.toStringAsFixed(0)} units',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            SizedBox(width: 36.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 5.h,
                                  backgroundColor: Colors.grey.shade100,
                                  color: cs.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${(pct * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// EXPENSES CARD
// ──────────────────────────────────────────────────────────────────────────────

class _ExpensesCard extends ConsumerWidget {
  static final _currency = NumberFormat.simpleCurrency(decimalDigits: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(purchaseSummaryProvider);
    final salesAsync = ref.watch(salesSummaryProvider);
    final period = ref.watch(reportPeriodProvider);

    return _Card(
      child: purchasesAsync.when(
        loading: () => SizedBox(
          height: 80.h,
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => _ErrorTile(message: e.toString()),
        data: (purchases) {
          final salesTotal = salesAsync.valueOrNull?.grandTotal ?? 0.0;
          final netProfit = salesTotal - purchases.totalLineValue;
          final isProfit = netProfit >= 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardHeader(title: 'Expenses & Purchases', subtitle: period.label),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Total Expenses',
                      value: _currency.format(purchases.totalLineValue),
                      icon: Icons.shopping_cart_outlined,
                      iconColor: const Color(0xFFE07B2A),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _MetricTile(
                      label: 'Receipts',
                      value: '${purchases.receiptCount}',
                      icon: Icons.receipt_outlined,
                      iconColor: const Color(0xFF9C27B0),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _MetricTile(
                      label: 'Items In',
                      value: purchases.totalQty.toStringAsFixed(0),
                      icon: Icons.inventory_outlined,
                      iconColor: const Color(0xFF00897B),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              Divider(color: Colors.grey.shade100, height: 1),
              SizedBox(height: 14.h),

              // Net profit row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Net Position (Sales − Expenses)',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              isProfit ? '+' : '−',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                color: isProfit
                                    ? const Color(0xFF15945B)
                                    : const Color(0xFFE14D3B),
                              ),
                            ),
                            Text(
                              _currency.format(netProfit.abs()),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w900,
                                color: isProfit
                                    ? const Color(0xFF15945B)
                                    : const Color(0xFFE14D3B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isProfit
                          ? const Color(0xFFE2FFD0)
                          : const Color(0xFFFFE0DC),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isProfit
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          size: 14.sp,
                          color: isProfit
                              ? const Color(0xFF3C8B15)
                              : const Color(0xFFE14D3B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isProfit ? 'Surplus' : 'Deficit',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: isProfit
                                ? const Color(0xFF3C8B15)
                                : const Color(0xFFE14D3B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),
              CategoryRow(
                title: 'Sales Revenue',
                value: _currency.format(salesTotal),
                percentage: '${salesTotal > 0 ? 100 : 0}%',
              ),
              SizedBox(height: 10.h),
              CategoryRow(
                title: 'Purchases / Expenses',
                value: _currency.format(purchases.totalLineValue),
                percentage: salesTotal > 0
                    ? '${(purchases.totalLineValue / salesTotal * 100).toStringAsFixed(0)}%'
                    : '0%',
              ),
            ],
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ──────────────────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF151515),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: iconColor),
          SizedBox(height: 8.h),
          FittedBox(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF151515),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Unable to load data',
              style: TextStyle(fontSize: 12.sp, color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDataWidget extends StatelessWidget {
  const _EmptyDataWidget({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FlutterRemix.bar_chart_grouped_fill,
              size: 36.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}