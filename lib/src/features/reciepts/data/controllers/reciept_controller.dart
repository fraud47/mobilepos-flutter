import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/reciept.dart';

class ReceiptController extends StateNotifier<List<Receipt>> {
  ReceiptController() : super(_demoData());

  static List<Receipt> _demoData() {
    return [
      Receipt(
        id: "SJ-136",
        paymentMethod: "Cash",
        date: DateTime.now(),
        items: 1,
        amount: 4,
      ),
      Receipt(
        id: "SJ-135",
        paymentMethod: "Cash",
        date: DateTime.now(),
        items: 1,
        amount: 13,
      ),
    ];
  }
}