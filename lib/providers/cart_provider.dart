import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/cart_state.dart';
import '../models/product.dart';
import '../repositories/cart_storage_exception.dart';
import '../repositories/cart_storage_repository.dart';
import '../repositories/shared_preferences_cart_storage_repository.dart';
import 'products_provider.dart';

final cartStorageProvider = Provider<CartStorageRepository>((ref) {
  return SharedPreferencesCartStorageRepository();
});

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final products = ref.watch(productsProvider);
  final storageRepository = ref.watch(cartStorageProvider);

  return CartNotifier(products: products, storageRepository: storageRepository);
});

final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider.select((state) => state.items));
});

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider.select((state) => state.totalQuantity));
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider.select((state) => state.totalPrice));
});

final cartIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider.select((state) => state.isLoading));
});

class CartNotifier extends StateNotifier<CartState> {
  final CartStorageRepository _storageRepository;
  final Map<String, Product> _productsById;

  bool _hasLocalMutation = false;
  Future<void> _storageWriteQueue = Future<void>.value();
  late final Future<void> _restoreCompleted;

  CartNotifier({
    required List<Product> products,
    required CartStorageRepository storageRepository,
  }) : _storageRepository = storageRepository,
       _productsById = Map.unmodifiable({
         for (final product in products) product.id: product,
       }),
       super(CartState(isLoading: true)) {
    _restoreCompleted = _restoreCart();
  }

  @visibleForTesting
  Future<void> get restoreCompleted => _restoreCompleted;

  @visibleForTesting
  Future<void> get storageWriteCompleted => _storageWriteQueue;

  void addProduct(Product product) {
    final hasProduct = state.items.any((item) => item.product.id == product.id);

    final updatedItems = hasProduct
        ? state.items
              .map(
                (item) => item.product.id == product.id
                    ? item.copyWith(quantity: item.quantity + 1)
                    : item,
              )
              .toList()
        : [...state.items, CartItem(product: product)];

    _updateItems(updatedItems);
    debugPrint('Added: ${product.name}');
  }

  void incrementProduct(String productId) {
    if (!_containsProduct(productId)) {
      return;
    }

    final updatedItems = state.items
        .map(
          (item) => item.product.id == productId
              ? item.copyWith(quantity: item.quantity + 1)
              : item,
        )
        .toList();

    _updateItems(updatedItems);
    debugPrint('Incremented: $productId');
  }

  void decrementProduct(String productId) {
    if (!_containsProduct(productId)) {
      return;
    }

    final updatedItems = state.items
        .map((item) {
          if (item.product.id != productId) {
            return item;
          }

          return item.quantity == 1
              ? null
              : item.copyWith(quantity: item.quantity - 1);
        })
        .whereType<CartItem>()
        .toList();

    _updateItems(updatedItems);
    debugPrint('Decremented: $productId');
  }

  void removeProduct(String productId) {
    if (!_containsProduct(productId)) {
      return;
    }

    final updatedItems = state.items
        .where((item) => item.product.id != productId)
        .toList();

    _updateItems(updatedItems);
    debugPrint('Removed: $productId');
  }

  void clear() {
    _hasLocalMutation = true;
    state = CartState();
    _queueStorageWrite(_storageRepository.clearCart);
    debugPrint('Cart cleared');
  }

  bool _containsProduct(String productId) {
    return state.items.any((item) => item.product.id == productId);
  }

  void _updateItems(List<CartItem> items) {
    _hasLocalMutation = true;
    state = CartState(items: items);
    _queueStorageWrite(() => _storageRepository.saveCartItems(items));
  }

  void _queueStorageWrite(Future<void> Function() operation) {
    _storageWriteQueue = _storageWriteQueue.then((_) => operation()).catchError(
      (Object error, StackTrace stackTrace) {
        debugPrint('Failed to update cart storage: $error');
      },
    );
  }

  Future<void> _restoreCart() async {
    try {
      final savedQuantities = await _storageRepository.loadCartQuantities();

      if (_hasLocalMutation) {
        return;
      }

      final restoredItems = savedQuantities.entries
          .map((entry) {
            final product = _productsById[entry.key];

            if (product == null) {
              return null;
            }

            return CartItem(product: product, quantity: entry.value);
          })
          .whereType<CartItem>()
          .toList();

      state = CartState(items: restoredItems);
    } on CartStorageException catch (error) {
      debugPrint('Failed to restore cart: $error');

      if (!_hasLocalMutation) {
        state = CartState();
      }
    }
  }
}
