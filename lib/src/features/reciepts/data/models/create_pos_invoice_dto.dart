class CreatePosInvoiceDto {
  final int branchId;
  final int warehouseId;
  final String postingDate;
  final List<PosItemDto> items;
  final List<PosPaymentDto> payments;

  CreatePosInvoiceDto({
    required this.branchId,
    required this.warehouseId,
    required this.postingDate,
    required this.items,
    required this.payments,
  });

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'warehouseId': warehouseId,
      'postingDate': postingDate,
      'items': items.map((item) => item.toJson()).toList(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
    };
  }
}

class PosItemDto {
  final int productId;
  final num qty;
  final num unitPrice;
  final num discountAmount;
  final num taxAmount;

  PosItemDto({
    required this.productId,
    required this.qty,
    required this.unitPrice,
    this.discountAmount = 0,
    this.taxAmount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'qty': qty,
      'unitPrice': unitPrice,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
    };
  }
}

class PosPaymentDto {
  final String paymentMethod;
  final num amount;

  PosPaymentDto({
    required this.paymentMethod,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'amount': amount,
    };
  }
}
