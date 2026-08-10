import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/counter/counter_stat_card.dart';
import 'package:mobilepos/src/features/reciepts/presentation/providers/reciept_provider.dart';

class CounterStatsGrid extends ConsumerWidget {
  const CounterStatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAsync = ref.watch(receiptProvider);

    return receiptsAsync.when(
      data: (receipts) {
        final now = DateTime.now();
        final todayReceipts = receipts.where((r) => 
          r.date.year == now.year && r.date.month == now.month && r.date.day == now.day
        ).toList();

        final todaySales = todayReceipts.fold<double>(0.0, (sum, r) => sum + r.amount);
        final transactions = todayReceipts.length;
        final itemsSold = todayReceipts.fold<int>(0, (sum, r) => sum + r.itemsCount);

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            CounterStatCard(
              title: 'Today Sales',
              value: '\$${todaySales.toStringAsFixed(2)}',
              icon: FlutterRemix.money_dollar_circle_fill,
              color: Colors.green,
            ),
            CounterStatCard(
              title: 'Transactions',
              value: transactions.toString(),
              icon: FlutterRemix.shopping_bag_fill,
              color: Colors.orange,
            ),
            CounterStatCard(
              title: 'Items Sold',
              value: itemsSold.toString(),
              icon: FlutterRemix.archive_fill,
              color: Colors.blue,
            ),
            const CounterStatCard(
              title: 'Pending',
              value: '0',
              icon: FlutterRemix.time_fill,
              color: Colors.red,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading stats')),
    );
  }
}
