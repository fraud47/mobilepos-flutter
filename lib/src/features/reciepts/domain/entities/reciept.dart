class ReceiptItem {
  final String productName;
  final double qty;
  final double unitPrice;
  final double lineTotal;

  const ReceiptItem({
    required this.productName,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      productName: json['productName']?.toString() ?? 'Unknown Product',
      qty: double.tryParse(json['qty']?.toString() ?? '1') ?? 1.0,
      unitPrice: double.tryParse(json['unitPrice']?.toString() ?? '0') ?? 0.0,
      lineTotal: double.tryParse(json['lineTotal']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'qty': qty,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
    };
  }
}

class Receipt {
  final String id;
  final int invoiceId;
  final String paymentMethod;
  final DateTime date;
  final int itemsCount;
  final List<ReceiptItem> items;
  final double amount;
  final double subtotal;
  final double taxTotal;
  final int? branchId;

  const Receipt({
    required this.id,
    required this.invoiceId,
    required this.paymentMethod,
    required this.date,
    required this.itemsCount,
    required this.items,
    required this.amount,
    required this.subtotal,
    required this.taxTotal,
    this.branchId,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    final postingDate = json['postingDate']?.toString() ?? '';
    final postingTime = json['postingTime']?.toString() ?? '';
    final fullDate = [postingDate, postingTime].where((s) => s.isNotEmpty).join(' ');
    
    DateTime parsedDate;
    try {
      parsedDate = fullDate.isNotEmpty ? DateTime.parse(fullDate) : (json['date'] != null ? DateTime.parse(json['date']) : DateTime.now());
    } catch (_) {
      parsedDate = DateTime.now();
    }

    final payments = json['payments'] as List<dynamic>? ?? [];
    final firstPaymentMethod = payments.isNotEmpty ? payments.first['paymentMethod']?.toString() : null;
    
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final parsedItems = itemsList.map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>)).toList();

    return Receipt(
      id: json['documentNo']?.toString() ?? json['id']?.toString() ?? '',
      invoiceId: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      date: parsedDate,
      amount: json['grandTotal'] is num ? (json['grandTotal'] as num).toDouble() : double.tryParse(json['grandTotal']?.toString() ?? json['amount']?.toString() ?? '0.0') ?? 0.0,
      subtotal: json['subtotal'] is num ? (json['subtotal'] as num).toDouble() : double.tryParse(json['subtotal']?.toString() ?? '0.0') ?? 0.0,
      taxTotal: json['taxTotal'] is num ? (json['taxTotal'] as num).toDouble() : double.tryParse(json['taxTotal']?.toString() ?? '0.0') ?? 0.0,
      paymentMethod: firstPaymentMethod ?? json['paymentMethod']?.toString() ?? 'CASH',
      itemsCount: itemsList.length,
      items: parsedItems,
      branchId: json['branchId'] is int ? json['branchId'] as int : int.tryParse(json['branchId']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String(),
      'itemsCount': itemsCount,
      'items': items.map((e) => e.toJson()).toList(),
      'amount': amount,
      'subtotal': subtotal,
      'taxTotal': taxTotal,
    };
  }
}