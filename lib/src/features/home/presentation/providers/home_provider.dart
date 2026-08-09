import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

import '../../../inventory/domain/entities/wholesale_item.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController();
});

enum HomeTab { reports, today, counter, items, more }

class HomeState {
  final HomeTab selectedTab;
  final List<CartItem> cartItems;
  final String itemSearchQuery;
  final bool isItemSearchVisible;
  final bool isItemsGridView;

  const HomeState({
    this.selectedTab = HomeTab.counter,
    this.cartItems = const [],
    this.itemSearchQuery = '',
    this.isItemSearchVisible = false,
    this.isItemsGridView = true,
  });

  bool get hasCartItems => cartItems.isNotEmpty;

  double get subtotal => cartItems.fold<double>(
        0,
        (total, item) => total + (item.product.price * item.quantity),
      );

  int get itemCount => cartItems.length;

  double get unitCount =>
      cartItems.fold<double>(0, (total, item) => total + item.quantity);

  int get unitBadgeCount => unitCount.ceil();

  double quantityFor(InventoryItem product) {
    for (final item in cartItems) {
      if (item.product.name == product.name) {
        return item.quantity;
      }
    }

    return 0;
  }

  List<InventoryItem> get filteredProducts {
    final query = itemSearchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return homeProducts;
    }

    return homeProducts.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.price.toStringAsFixed(2).contains(query) ||
          product.stock.toString().contains(query);
    }).toList();
  }

  HomeState copyWith({
    HomeTab? selectedTab,
    List<CartItem>? cartItems,
    String? itemSearchQuery,
    bool? isItemSearchVisible,
    bool? isItemsGridView,
  }) {
    return HomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      cartItems: cartItems ?? this.cartItems,
      itemSearchQuery: itemSearchQuery ?? this.itemSearchQuery,
      isItemSearchVisible: isItemSearchVisible ?? this.isItemSearchVisible,
      isItemsGridView: isItemsGridView ?? this.isItemsGridView,
    );
  }
}

typedef ProductQuantityChanged = void Function(
  InventoryItem product,
  double quantity,
);

String formatQuantity(double quantity) {
  if (quantity == quantity.roundToDouble()) {
    return quantity.toInt().toString();
  }

  return quantity
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState());

  void selectTab(HomeTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void startNewSale() {
    state = state.copyWith(selectedTab: HomeTab.items);
  }

  void setItemSearchQuery(String query) {
    state = state.copyWith(itemSearchQuery: query);
  }

  void toggleItemsLayout() {
    state = state.copyWith(isItemsGridView: !state.isItemsGridView);
  }

  void showItemSearch() {
    state = state.copyWith(isItemSearchVisible: true);
  }

  void hideItemSearch() {
    state = state.copyWith(
      isItemSearchVisible: false,
      itemSearchQuery: '',
    );
  }

  void updateProductQuantity(
    InventoryItem product,
    double quantity,
  ) {
    final updatedCart = [...state.cartItems];

    final existingIndex = updatedCart.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (existingIndex < 0) {
      if (quantity > 0) {
        updatedCart.add(CartItem(product: product, quantity: quantity));
        state = state.copyWith(cartItems: updatedCart);
      }
      return;
    }

    if (quantity <= 0) {
      updatedCart.removeAt(existingIndex);
    } else {
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        quantity: quantity,
      );
    }

    state = state.copyWith(cartItems: updatedCart);
  }

  void addProduct(InventoryItem product) {
    final existingIndex = state.cartItems.indexWhere(
      (item) => item.product.name == product.name,
    );

    final updatedCart = [...state.cartItems];
    if (existingIndex >= 0) {
      final current = updatedCart[existingIndex];
      updatedCart[existingIndex] = current.copyWith(
        quantity: current.quantity + 1,
      );
    } else {
      updatedCart.add(CartItem(product: product));
    }

    state = state.copyWith(cartItems: updatedCart);
  }

  void incrementProduct(InventoryItem product) {
    addProduct(product);
  }

  void decrementProduct(InventoryItem product) {
    final updatedCart = [...state.cartItems];
    final existingIndex = updatedCart.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (existingIndex < 0) {
      return;
    }

    final current = updatedCart[existingIndex];
    if (current.quantity <= 1) {
      updatedCart.removeAt(existingIndex);
    } else {
      updatedCart[existingIndex] = current.copyWith(
        quantity: current.quantity - 1,
      );
    }

    state = state.copyWith(cartItems: updatedCart);
  }

  void removeProduct(InventoryItem product) {
    state = state.copyWith(
      cartItems: state.cartItems
          .where((item) => item.product.name != product.name)
          .toList(),
    );
  }

  void clearCart() {
    state = state.copyWith(cartItems: const []);
  }
}

class CartItem {
  final InventoryItem product;
  final double quantity;

  const CartItem({
    required this.product,
    this.quantity = 1,
  });

  CartItem copyWith({
    InventoryItem? product,
    double? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

final homeProducts = [
  InventoryItem(
      name: "Coca Cola 2L",
      stock: 124,
      price: 2.50,
      image: "https://images.unsplash.com/photo-1629203851122-3726ecdf080e",
      wholesalePrices: [
        WholesaleTier(minimumQuantity: 6, price: 2.30),
        WholesaleTier(minimumQuantity: 12, price: 2.10),
        WholesaleTier(minimumQuantity: 24, price: 1.95),
      ],
      enableWholesale: true),
  InventoryItem(
    name: "Cooking Oil",
    stock: 34,
    price: 5.99,
    image: "https://images.unsplash.com/photo-1620706857370-e1b9770e8bb1",
    wholesalePrices: [
      WholesaleTier(minimumQuantity: 5, price: 5.70),
      WholesaleTier(minimumQuantity: 10, price: 5.40),
      WholesaleTier(minimumQuantity: 20, price: 5.10),
    ],
    enableWholesale: true,
  ),
  InventoryItem(
      name: "Sugar 2kg",
      stock: 10,
      price: 3.20,
      image: "https://images.unsplash.com/photo-1586201375761-83865001e31c",
      wholesalePrices: [
        WholesaleTier(minimumQuantity: 5, price: 3.00),
        WholesaleTier(minimumQuantity: 10, price: 2.80),
      ],
      enableWholesale: true),
  InventoryItem(
      name: "Rice 10kg",
      stock: 0,
      price: 12.99,
      image: "https://images.unsplash.com/photo-1516684732162-798a0062be99",
      wholesalePrices: [
        WholesaleTier(minimumQuantity: 2, price: 12.50),
        WholesaleTier(minimumQuantity: 5, price: 11.99),
        WholesaleTier(minimumQuantity: 10, price: 11.50),
      ],
      enableWholesale: true),
];
