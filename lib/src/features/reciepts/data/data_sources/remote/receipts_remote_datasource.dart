import '../../../domain/entities/reciept.dart';
import '../../models/create_pos_invoice_dto.dart';

abstract class ReceiptsRemoteDataSource {
  Future<List<Receipt>> getReceipts();
  Future<void> createInvoice(CreatePosInvoiceDto payload);
}
