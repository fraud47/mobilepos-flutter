import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/reciept.dart';

class ReceiptController extends StateNotifier<List<Receipt>> {
  ReceiptController() : super(_demoData());

  static List<Receipt> _demoData() {
    return [
      Receipt(
        id: "SJ-136",
        invoiceId: 136,
        paymentMethod: "Cash",
        date: DateTime.now(),
        itemsCount: 1,
        items: const [],
        amount: 4,
        subtotal: 4,
        taxTotal: 0,
      ),
      Receipt(
        id: "SJ-135",
        invoiceId: 135,
        paymentMethod: "Cash",
        date: DateTime.now(),
        itemsCount: 1,
        items: const [],
        amount: 13,
        subtotal: 13,
        taxTotal: 0,
      ),
    ];
  }
}