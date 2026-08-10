import 'package:fpdart/fpdart.dart';
import 'package:mobilepos/src/utils/failure.dart';
import 'package:mobilepos/src/utils/utils.dart';
import '../../domain/entities/reciept.dart';
import '../models/create_pos_invoice_dto.dart';

abstract class ReceiptsRepository {
  FutureEither<List<Receipt>> getReceipts();
  FutureEither<void> createInvoice(CreatePosInvoiceDto payload);
  FutureEither<void> cancelInvoice(int invoiceId);
}
