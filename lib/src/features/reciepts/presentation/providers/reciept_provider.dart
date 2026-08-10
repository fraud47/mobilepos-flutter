import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/branches/presentation/providers/branch_provider.dart';
import '../../domain/entities/reciept.dart';
import '../../data/data_sources/impl/receipts_remote_datasource_impl.dart';
import '../../data/repositories/receipts_repository_impl.dart';
import '../../data/repositories/receipts_repository.dart';

final receiptsRepositoryProvider = Provider<ReceiptsRepository>((ref) {
  return ReceiptsRepositoryImpl(ReceiptsRemoteDataSourceImpl.instance);
});

final receiptProvider = FutureProvider<List<Receipt>>((ref) async {
  final repository = ref.watch(receiptsRepositoryProvider);
  final activeBranch = ref.watch(activeBranchProvider);
  
  final result = await repository.getReceipts();
  
  return result.fold(
    (failure) => throw failure.message,
    (receipts) {
      if (activeBranch == null) return receipts;
      return receipts.where((r) => r.branchId == activeBranch.id).toList();
    },
  );
});

class CancelReceiptNotifier extends StateNotifier<AsyncValue<void>> {
  final ReceiptsRepository _repository;
  final Ref _ref;

  CancelReceiptNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<bool> cancelReceipt(int invoiceId) async {
    state = const AsyncValue.loading();
    final result = await _repository.cancelInvoice(invoiceId);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(receiptProvider);
        return true;
      },
    );
  }
}

final cancelReceiptControllerProvider = StateNotifierProvider<CancelReceiptNotifier, AsyncValue<void>>((ref) {
  return CancelReceiptNotifier(ref.watch(receiptsRepositoryProvider), ref);
});