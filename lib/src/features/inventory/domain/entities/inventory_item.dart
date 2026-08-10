import 'wholesale_item.dart';

class InventoryItem {
  final String? id;
  final String name;
  final int stock;
  final double price;
  final double? costPrice;
  final String image;
  final bool enableWholesale;
  final List<WholesaleTier> wholesalePrices;
  final int? branchId;
  final String? sku;
  final String? category;
  final int? categoryId;
  final String? description;
  final String? barcode;

  InventoryItem({
    this.id,
    required this.name,
    required this.stock,
    required this.price,
    this.costPrice,
    required this.image,
    required this.enableWholesale,
    required this.wholesalePrices,
    this.branchId,
    this.sku,
    this.category,
    this.categoryId,
    this.description,
    this.barcode,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    final wholesaleTiers = (json['wholesaleTiers'] as List<dynamic>?)
            ?.map((e) => WholesaleTier.fromJson(e as Map<String, dynamic>))
            .toList() ??
        (json['wholesalePrices'] as List<dynamic>?)
            ?.map((e) => WholesaleTier.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];

    final catObj = json['category'];
    String? categoryName;
    int? parsedCatId;

    if (catObj is Map) {
      categoryName = catObj['name']?.toString();
      parsedCatId = catObj['id'] is int ? catObj['id'] as int : int.tryParse(catObj['id']?.toString() ?? '');
    } else if (catObj != null) {
      categoryName = catObj.toString();
    }

    if (parsedCatId == null && json['categoryId'] != null) {
      parsedCatId = json['categoryId'] is int ? json['categoryId'] as int : int.tryParse(json['categoryId'].toString());
    }

    return InventoryItem(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      price: json['sellingPrice'] is num ? (json['sellingPrice'] as num).toDouble() : double.tryParse(json['sellingPrice']?.toString() ?? json['price']?.toString() ?? '0.0') ?? 0.0,
      costPrice: json['costPrice'] is num ? (json['costPrice'] as num).toDouble() : double.tryParse(json['costPrice']?.toString() ?? '0.0'),
      image: json['image']?.toString() ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e',
      enableWholesale: wholesaleTiers.isNotEmpty || json['enableWholesale'] == true || json['enableWholesale'] == 'true',
      wholesalePrices: wholesaleTiers,
      branchId: json['branchId'] is int ? json['branchId'] as int : int.tryParse(json['branchId']?.toString() ?? ''),
      sku: json['sku']?.toString(),
      category: categoryName,
      categoryId: parsedCatId,
      description: json['description']?.toString(),
      barcode: json['barcode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'stock': stock,
      'price': price,
      if (costPrice != null) 'costPrice': costPrice,
      'image': image,
      'enableWholesale': enableWholesale,
      'wholesalePrices': wholesalePrices.map((e) => e.toJson()).toList(),
      if (sku != null) 'sku': sku,
      if (category != null) 'category': category,
      if (categoryId != null) 'categoryId': categoryId,
      if (description != null) 'description': description,
      if (barcode != null) 'barcode': barcode,
    };
  }
}
