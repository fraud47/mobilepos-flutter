class Receipt {
  final String id;
  final String paymentMethod;
  final DateTime date;
  final int items;
  final double amount;

  const Receipt({
    required this.id,
    required this.paymentMethod,
    required this.date,
    required this.items,
    required this.amount,
  });
}