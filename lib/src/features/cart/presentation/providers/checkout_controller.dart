import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'package:mobilepos/src/features/reciepts/data/models/create_pos_invoice_dto.dart';
import 'package:mobilepos/src/features/branches/presentation/providers/branch_provider.dart';
import 'package:mobilepos/src/features/reciepts/data/repositories/receipts_repository.dart';
import 'package:mobilepos/src/features/reciepts/presentation/providers/reciept_provider.dart';

class CheckoutController extends StateNotifier<AsyncValue<void>> {
  final ReceiptsRepository _repository;
  final Ref _ref;
  CheckoutController(this._repository, this._ref) : super(const AsyncData(null));

  Future<bool> checkoutCash(HomeState homeState) async {
    state = const AsyncLoading();

    // 1. Build the DTO
    final items = homeState.cartItems.map((cartItem) {
      return PosItemDto(
        productId: int.tryParse(cartItem.product.id ?? '') ?? 0,
        qty: cartItem.quantity,
        unitPrice: cartItem.product.price,
        discountAmount: 0,
        taxAmount: 0,
      );
    }).toList();

    // The total includes VAT as per the UI
    final total = homeState.subtotal + (homeState.subtotal * 0.155);

    final activeBranch = _ref.read(activeBranchProvider);
    if (activeBranch == null) {
      state = AsyncError('No branch selected', StackTrace.current);
      return false;
    }

    final payload = CreatePosInvoiceDto(
      branchId: activeBranch.id,
      warehouseId: 1, // Hardcoded for MVP
      postingDate: DateTime.now().toIso8601String().split('T')[0], // e.g. 2026-08-10
      items: items,
      payments: [
        PosPaymentDto(
          paymentMethod: 'CASH',
          amount: total,
        ),
      ],
    );

    // 2. Call API
    final result = await _repository.createInvoice(payload);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}

final checkoutControllerProvider = StateNotifierProvider<CheckoutController, AsyncValue<void>>((ref) {
  final repository = ref.watch(receiptsRepositoryProvider);
  return CheckoutController(repository, ref);
});
