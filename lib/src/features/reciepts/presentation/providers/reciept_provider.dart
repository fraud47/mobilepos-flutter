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