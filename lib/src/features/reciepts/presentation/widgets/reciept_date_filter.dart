import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/receipt_date_filter_provider.dart';
import 'date_box.dart';

class ReceiptDateFilter extends ConsumerWidget {
  const ReceiptDateFilter({super.key});

  static final _fmt = DateFormat('dd MMM yyyy');

  Future<void> _pickFromDate(BuildContext context, WidgetRef ref) async {
    final current = ref.read(dateFilterProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: current.fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select FROM date',
    );
    if (picked != null) {
      ref.read(dateFilterProvider.notifier).setFromDate(picked);
    }
  }

  Future<void> _pickToDate(BuildContext context, WidgetRef ref) async {
    final current = ref.read(dateFilterProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: current.toDate,
      firstDate: current.fromDate,
      lastDate: DateTime.now(),
      helpText: 'Select TO date',
    );
    if (picked != null) {
      ref.read(dateFilterProvider.notifier).setToDate(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(dateFilterProvider);

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          Expanded(
            child: DateBox(
              title: 'From',
              date: _fmt.format(filter.fromDate),
              onTap: () => _pickFromDate(context, ref),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white24,
          ),
          Expanded(
            child: DateBox(
              title: 'To',
              date: _fmt.format(filter.toDate),
              onTap: () => _pickToDate(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}