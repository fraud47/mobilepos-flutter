import 'wholesale_item.dart';

class InventoryItem {
  final String? id;
  final String name;
  final int stock;
  final double price;
  final String image;
  final bool enableWholesale;
  final List<WholesaleTier> wholesalePrices;
  final int? branchId;

  InventoryItem({
    this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.image,
    required this.enableWholesale,
    required this.wholesalePrices,
    this.branchId,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    final wholesaleTiers = (json['wholesaleTiers'] as List<dynamic>?)
            ?.map((e) => WholesaleTier.fromJson(e as Map<String, dynamic>))
            .toList() ??
        (json['wholesalePrices'] as List<dynamic>?)
            ?.map((e) => WholesaleTier.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];

    return InventoryItem(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      price: json['sellingPrice'] is num ? (json['sellingPrice'] as num).toDouble() : double.tryParse(json['sellingPrice']?.toString() ?? json['price']?.toString() ?? '0.0') ?? 0.0,
      image: json['image']?.toString() ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e',
      enableWholesale: wholesaleTiers.isNotEmpty || json['enableWholesale'] == true || json['enableWholesale'] == 'true',
      wholesalePrices: wholesaleTiers,
      branchId: json['branchId'] is int ? json['branchId'] as int : int.tryParse(json['branchId']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'stock': stock,
      'price': price,
      'image': image,
      'enableWholesale': enableWholesale,
      'wholesalePrices': wholesalePrices.map((e) => e.toJson()).toList(),
    };
  }
}
