import 'package:mobilepos/src/features/inventory/domain/entities/inventory_item.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/branches/presentation/providers/branch_provider.dart';
import 'package:mobilepos/src/core/sync/offline_sync_service.dart';

import '../../../inventory/domain/entities/wholesale_item.dart';
import 'package:mobilepos/src/features/inventory/data/data_sources/impl/inventory_remote_datasource_impl.dart';
import 'package:mobilepos/src/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:mobilepos/src/features/inventory/data/repositories/inventory_repository.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController();
});

enum HomeTab { reports, counter, items }

class HomeState {
  final HomeTab selectedTab;
  final List<CartItem> cartItems;
  final String itemSearchQuery;
  final bool isItemSearchVisible;
  final bool isItemsGridView;
  final String counterSearchQuery;
  final bool isCheckoutView;

  const HomeState({
    this.selectedTab = HomeTab.counter,
    this.cartItems = const [],
    this.itemSearchQuery = '',
    this.isItemSearchVisible = false,
    this.isItemsGridView = true,
    this.counterSearchQuery = '',
    this.isCheckoutView = false,
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

  HomeState copyWith({
    HomeTab? selectedTab,
    List<CartItem>? cartItems,
    String? itemSearchQuery,
    bool? isItemSearchVisible,
    bool? isItemsGridView,
    String? counterSearchQuery,
    bool? isCheckoutView,
  }) {
    return HomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      cartItems: cartItems ?? this.cartItems,
      itemSearchQuery: itemSearchQuery ?? this.itemSearchQuery,
      isItemSearchVisible: isItemSearchVisible ?? this.isItemSearchVisible,
      isItemsGridView: isItemsGridView ?? this.isItemsGridView,
      counterSearchQuery: counterSearchQuery ?? this.counterSearchQuery,
      isCheckoutView: isCheckoutView ?? this.isCheckoutView,
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
    state = state.copyWith(selectedTab: tab, isCheckoutView: false);
  }

  void startNewSale() {
    state = state.copyWith(
      selectedTab: HomeTab.items,
      isCheckoutView: false,
    );
  }

  void proceedToCheckout() {
    if (state.hasCartItems) {
      state = state.copyWith(isCheckoutView: true);
    }
  }

  void backToCounter() {
    state = state.copyWith(isCheckoutView: false);
  }

  void setItemSearchQuery(String query) {
    state = state.copyWith(itemSearchQuery: query);
  }

  void setCounterSearchQuery(String query) {
    state = state.copyWith(counterSearchQuery: query);
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
    state = state.copyWith(
      cartItems: const [],
      isCheckoutView: false,
    );
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

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl(InventoryRemoteDataSourceImpl.instance);
});

final homeProductsProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final syncService = ref.watch(offlineSyncServiceProvider);
  final repository = ref.watch(inventoryRepositoryProvider);
  final activeBranch = ref.watch(activeBranchProvider);
  
  final result = await repository.getInventory(branchId: activeBranch?.id);
  
  return result.fold(
    (failure) async {
      // Fallback to local SQLite cache if offline or remote error occurs
      final cached = await syncService.getCachedProducts();
      if (cached.isNotEmpty) {
        return cached;
      }
      throw failure.message;
    },
    (inventory) {
      // Automatically cache fresh products locally in SQLite
      syncService.cacheProductsLocally(inventory);
      return inventory;
    },
  );
});

final filteredProductsProvider = Provider<AsyncValue<List<InventoryItem>>>((ref) {
  final homeState = ref.watch(homeControllerProvider);
  final asyncProducts = ref.watch(homeProductsProvider);

  return asyncProducts.whenData((products) {
    final query = homeState.itemSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return products;
    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.price.toStringAsFixed(2).contains(query) ||
          product.stock.toString().contains(query);
    }).toList();
  });
});

/// Products filtered for the Counter tab's inline search.
final counterFilteredProductsProvider = Provider<AsyncValue<List<InventoryItem>>>((ref) {
  final homeState = ref.watch(homeControllerProvider);
  final asyncProducts = ref.watch(homeProductsProvider);

  return asyncProducts.whenData((products) {
    final query = homeState.counterSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return products;
    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.price.toStringAsFixed(2).contains(query);
    }).toList();
  });
});
