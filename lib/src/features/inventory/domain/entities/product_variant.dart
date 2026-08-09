import 'wholesale_price.dart';

class ProductVariant {
  String name;

  double sellingPrice;

  double costPrice;

  int stock;

  int lowStock;

  String sku;

  String barcode;

  List<WholesalePrice> wholesalePrices;

  ProductVariant({
    required this.name,
    required this.sellingPrice,
    required this.costPrice,
    required this.stock,
    required this.sku,
    required this.barcode,
    required this.lowStock,
    required this.wholesalePrices,
  });

  factory ProductVariant.empty() {
    return ProductVariant(
      name: "",
      sellingPrice: 0,
      costPrice: 0,
      stock: 0,
      sku: "",
      barcode: "",
      lowStock: 5,
      wholesalePrices: [],
    );
  }
}
