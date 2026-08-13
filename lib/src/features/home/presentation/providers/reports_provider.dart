import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/reports_remote_datasource.dart';

// ---------------------------------------------------------------------------
// Period enum
// ---------------------------------------------------------------------------

enum ReportPeriod { today, month, year }

extension ReportPeriodX on ReportPeriod {
  String get label {
    return switch (this) {
      ReportPeriod.today => 'Today',
      ReportPeriod.month => 'This Month',
      ReportPeriod.year => 'This Year',
    };
  }

  (DateTime from, DateTime to) get dateRange {
    final now = DateTime.now();
    return switch (this) {
      ReportPeriod.today => (
          DateTime(now.year, now.month, now.day),
          DateTime(now.year, now.month, now.day, 23, 59, 59),
        ),
      ReportPeriod.month => (
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        ),
      ReportPeriod.year => (
          DateTime(now.year, 1, 1),
          DateTime(now.year, 12, 31, 23, 59, 59),
        ),
    };
  }
}

// ---------------------------------------------------------------------------
// Period provider (StateNotifier)
// ---------------------------------------------------------------------------

final reportPeriodProvider =
    StateNotifierProvider<ReportPeriodNotifier, ReportPeriod>(
  (ref) => ReportPeriodNotifier(),
);

class ReportPeriodNotifier extends StateNotifier<ReportPeriod> {
  ReportPeriodNotifier() : super(ReportPeriod.today);

  void select(ReportPeriod period) => state = period;
}

// ---------------------------------------------------------------------------
// Sales summary provider
// ---------------------------------------------------------------------------

final salesSummaryProvider = FutureProvider<SalesSummary>((ref) async {
  final period = ref.watch(reportPeriodProvider);
  final (from, to) = period.dateRange;
  try {
    return await ReportsRemoteDataSource.instance.getSalesSummary(from, to);
  } catch (_) {
    return const SalesSummary(grandTotal: 0, invoiceCount: 0);
  }
});

// ---------------------------------------------------------------------------
// Sales by product provider
// ---------------------------------------------------------------------------

final salesByProductProvider =
    FutureProvider<List<SalesByProduct>>((ref) async {
  final period = ref.watch(reportPeriodProvider);
  final (from, to) = period.dateRange;
  try {
    return await ReportsRemoteDataSource.instance.getSalesByProduct(from, to);
  } catch (_) {
    return [];
  }
});

// ---------------------------------------------------------------------------
// Expenses / purchases provider
// ---------------------------------------------------------------------------

final purchaseSummaryProvider = FutureProvider<PurchaseSummary>((ref) async {
  final period = ref.watch(reportPeriodProvider);
  final (from, to) = period.dateRange;
  try {
    return await ReportsRemoteDataSource.instance.getPurchaseSummary(from, to);
  } catch (_) {
    return const PurchaseSummary(
        receiptCount: 0, totalLineValue: 0, totalQty: 0);
  }
});
