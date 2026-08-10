import 'package:fpdart/fpdart.dart';
import 'package:mobilepos/src/core/errors/exceptions.dart';
import 'package:mobilepos/src/utils/failure.dart';
import 'package:mobilepos/src/utils/utils.dart';
import '../../domain/entities/reciept.dart';
import '../data_sources/remote/receipts_remote_datasource.dart';
import '../models/create_pos_invoice_dto.dart';
import 'receipts_repository.dart';

class ReceiptsRepositoryImpl implements ReceiptsRepository {
  final ReceiptsRemoteDataSource remoteDataSource;

  ReceiptsRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<List<Receipt>> getReceipts() async {
    try {
      final receipts = await remoteDataSource.getReceipts();
      return right(receipts);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> createInvoice(CreatePosInvoiceDto payload) async {
    try {
      await remoteDataSource.createInvoice(payload);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  FutureEither<void> cancelInvoice(int invoiceId) async {
    try {
      await remoteDataSource.cancelInvoice(invoiceId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
