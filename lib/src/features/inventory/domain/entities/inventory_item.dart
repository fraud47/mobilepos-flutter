import 'wholesale_item.dart';

class InventoryItem {
  final String name;
  final int stock;
  final double price;
  final String image;
  final bool enableWholesale;
  final List<WholesaleTier> wholesalePrices;

  InventoryItem({
    required this.name,
    required this.stock,
    required this.price,
    required this.image,
    required this.enableWholesale,
    required this.wholesalePrices,
  });
}
