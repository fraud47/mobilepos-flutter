import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mobilepos/src/features/home/presentation/widgets/counter/counter_stat_card.dart';

class CounterStatsGrid extends StatelessWidget {
  const CounterStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: const [
        CounterStatCard(
          title: 'Today Sales',
          value: r'$1,250',
          icon: FlutterRemix.money_dollar_circle_fill,
          color: Colors.green,
        ),
        CounterStatCard(
          title: 'Transactions',
          value: '35',
          icon: FlutterRemix.shopping_bag_fill,
          color: Colors.orange,
        ),
        CounterStatCard(
          title: 'Items Sold',
          value: '152',
          icon: FlutterRemix.archive_fill,
          color: Colors.blue,
        ),
        CounterStatCard(
          title: 'Pending',
          value: '3',
          icon: FlutterRemix.time_fill,
          color: Colors.red,
        ),
      ],
    );
  }
}
