import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr11_state_management_riverpod/models/cart_item.dart';
import 'package:lr11_state_management_riverpod/models/product.dart';
import 'package:lr11_state_management_riverpod/providers/cart_provider.dart';
import 'package:lr11_state_management_riverpod/providers/products_provider.dart';
import 'package:lr11_state_management_riverpod/repositories/cart_storage_repository.dart';

void main() {
  group('cart providers', () {
    test(
      'addProduct increments quantity and total for duplicate products',
      () async {
        final storage = FakeCartStorageRepository();
        final container = createContainer(storage: storage);
        final notifier = container.read(cartProvider.notifier);
        final product = container.read(productsProvider).first;

        await notifier.restoreCompleted;

        notifier.addProduct(product);
        notifier.addProduct(product);
        await notifier.storageWriteCompleted;

        expect(container.read(cartCountProvider), 2);
        expect(container.read(cartTotalProvider), product.price * 2);
        expect(container.read(cartItemsProvider).single.quantity, 2);
        expect(storage.savedQuantities, {product.id: 2});
      },
    );

    test('decrementProduct removes item when quantity reaches zero', () async {
      final storage = FakeCartStorageRepository();
      final container = createContainer(storage: storage);
      final notifier = container.read(cartProvider.notifier);
      final product = container.read(productsProvider).first;

      await notifier.restoreCompleted;

      notifier.addProduct(product);
      notifier.decrementProduct(product.id);
      await notifier.storageWriteCompleted;

      expect(container.read(cartItemsProvider), isEmpty);
      expect(container.read(cartCountProvider), 0);
      expect(container.read(cartTotalProvider), 0.0);
      expect(storage.savedQuantities, isEmpty);
    });

    test('restore loads saved quantities from storage', () async {
      final products = testProducts();
      final storage = FakeCartStorageRepository(
        initialQuantities: {products.first.id: 2},
      );
      final container = createContainer(products: products, storage: storage);
      final notifier = container.read(cartProvider.notifier);

      await notifier.restoreCompleted;

      expect(container.read(cartCountProvider), 2);
      expect(container.read(cartTotalProvider), products.first.price * 2);
      expect(
        container.read(cartItemsProvider).single.product.id,
        products.first.id,
      );
    });

    test('restore does not overwrite local cart changes', () async {
      final products = testProducts();
      final restoreCompleter = Completer<Map<String, int>>();
      final storage = FakeCartStorageRepository(
        loadCart: () => restoreCompleter.future,
      );
      final container = createContainer(products: products, storage: storage);
      final notifier = container.read(cartProvider.notifier);

      notifier.addProduct(products.last);
      restoreCompleter.complete({products.first.id: 3});

      await notifier.restoreCompleted;
      await notifier.storageWriteCompleted;

      expect(container.read(cartCountProvider), 1);
      expect(
        container.read(cartItemsProvider).single.product.id,
        products.last.id,
      );
      expect(storage.savedQuantities, {products.last.id: 1});
    });

    test('clear removes cart items and clears persisted storage', () async {
      final storage = FakeCartStorageRepository();
      final container = createContainer(storage: storage);
      final notifier = container.read(cartProvider.notifier);
      final product = container.read(productsProvider).first;

      await notifier.restoreCompleted;

      notifier.addProduct(product);
      notifier.clear();
      await notifier.storageWriteCompleted;

      expect(container.read(cartItemsProvider), isEmpty);
      expect(container.read(cartCountProvider), 0);
      expect(storage.savedQuantities, isEmpty);
      expect(storage.didClear, isTrue);
    });
  });
}

ProviderContainer createContainer({
  List<Product>? products,
  CartStorageRepository? storage,
}) {
  final container = ProviderContainer(
    overrides: [
      productsProvider.overrideWithValue(products ?? testProducts()),
      cartStorageProvider.overrideWithValue(
        storage ?? FakeCartStorageRepository(),
      ),
    ],
  );

  addTearDown(container.dispose);
  return container;
}

List<Product> testProducts() {
  return [
    Product(
      id: 'phone',
      name: 'Phone',
      price: 500,
      category: 'Electronics',
      image: 'phone',
    ),
    Product(
      id: 'book',
      name: 'Book',
      price: 25,
      category: 'Books',
      image: 'book',
    ),
  ];
}

class FakeCartStorageRepository implements CartStorageRepository {
  final Map<String, int> _initialQuantities;
  final Future<Map<String, int>> Function()? _loadCart;

  Map<String, int> savedQuantities = const {};
  bool didClear = false;

  FakeCartStorageRepository({
    Map<String, int> initialQuantities = const {},
    Future<Map<String, int>> Function()? loadCart,
  }) : _initialQuantities = Map.unmodifiable(initialQuantities),
       _loadCart = loadCart;

  @override
  Future<Map<String, int>> loadCartQuantities() async {
    final loadCart = _loadCart;
    if (loadCart != null) {
      return Map.unmodifiable(await loadCart());
    }

    return _initialQuantities;
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    savedQuantities = Map.unmodifiable({
      for (final item in items) item.product.id: item.quantity,
    });
  }

  @override
  Future<void> clearCart() async {
    savedQuantities = const {};
    didClear = true;
  }
}
