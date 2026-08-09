import 'dart:ui';

class CartItemVisual {
  const CartItemVisual({
    required this.description,
    required this.imageUrl,
    required this.fallbackColor,
  });

  final String description;
  final String imageUrl;
  final Color fallbackColor;

  static CartItemVisual forIndex(int index) {
    return _visuals[index % _visuals.length];
  }

  
  static const _visuals = [
    CartItemVisual(
      description: 'Fresh stock item prepared for quick checkout.',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80',
      fallbackColor: Color(0xFFE8A149),
    ),
    CartItemVisual(
      description: 'Customer favorite with reliable daily sales.',
      imageUrl:
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?auto=format&fit=crop&w=400&q=80',
      fallbackColor: Color(0xFFE9513D),
    ),
    CartItemVisual(
      description: 'Popular shelf item ready for the counter.',
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=400&q=80',
      fallbackColor: Color(0xFF49785D),
    ),
    CartItemVisual(
      description: 'Well-stocked product selected for this order.',
      imageUrl:
          'https://images.unsplash.com/photo-1529042410759-befb1204b468?auto=format&fit=crop&w=400&q=80',
      fallbackColor: Color(0xFFCD6F41),
    ),
  ];}