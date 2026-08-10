class WholesaleTier {
  final int minimumQuantity;
  final double price;

  WholesaleTier({
    required this.minimumQuantity,
    required this.price,
  });

  factory WholesaleTier.fromJson(Map<String, dynamic> json) {
    return WholesaleTier(
      minimumQuantity: json['minQty'] is int ? json['minQty'] : int.tryParse(json['minQty']?.toString() ?? json['minimumQuantity']?.toString() ?? '0') ?? 0,
      price: json['price'] is num ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimumQuantity': minimumQuantity,
      'price': price,
    };
  }
}
