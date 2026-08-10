class Receipt {
  final String id;
  final String paymentMethod;
  final DateTime date;
  final int items;
  final double amount;
  final int? branchId;

  const Receipt({
    required this.id,
    required this.paymentMethod,
    required this.date,
    required this.items,
    required this.amount,
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

    return Receipt(
      id: json['documentNo']?.toString() ?? json['id']?.toString() ?? '',
      date: parsedDate,
      amount: json['grandTotal'] is num ? (json['grandTotal'] as num).toDouble() : double.tryParse(json['grandTotal']?.toString() ?? json['amount']?.toString() ?? '0.0') ?? 0.0,
      paymentMethod: firstPaymentMethod ?? json['paymentMethod']?.toString() ?? 'CASH',
      items: itemsList.length,
      branchId: json['branchId'] is int ? json['branchId'] as int : int.tryParse(json['branchId']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String(),
      'items': items,
      'amount': amount,
    };
  }
}