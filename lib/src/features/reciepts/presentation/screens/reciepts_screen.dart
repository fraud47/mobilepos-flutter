import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reciept_provider.dart';
import '../widgets/reciept_app_bar.dart';
import '../widgets/reciept_date_filter.dart';
import '../widgets/reciept_filter_button.dart';
import '../widgets/reciept_list.dart';

class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref.watch(receiptProvider);

    return Scaffold(
      appBar: const ReceiptAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ReceiptDateFilter(),
          Expanded(
            child: ReceiptList(
              receipts: receipts,
            ),
          ),
        ],
      ),
      floatingActionButton: const ReceiptFilterButton(),
    );
  }
}