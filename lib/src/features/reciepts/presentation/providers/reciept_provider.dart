import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/controllers/reciept_controller.dart';
import '../../domain/entities/reciept.dart';

final receiptProvider =
StateNotifierProvider<ReceiptController, List<Receipt>>((ref) {
  return ReceiptController();
});