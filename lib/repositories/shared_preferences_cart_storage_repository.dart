import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/stored_cart_item.dart';
import 'cart_storage_exception.dart';
import 'cart_storage_repository.dart';

class SharedPreferencesCartStorageRepository implements CartStorageRepository {
  static const String _cartKey = 'shopping_cart_items';

  final Future<SharedPreferences> Function() _getPreferences;

  SharedPreferencesCartStorageRepository({
    Future<SharedPreferences> Function()? getPreferences,
  }) : _getPreferences = getPreferences ?? SharedPreferences.getInstance;

  @override
  Future<Map<String, int>> loadCartQuantities() async {
    SharedPreferences? prefs;

    try {
      prefs = await _getPreferences();
      final encodedCart = prefs.getString(_cartKey);

      if (encodedCart == null || encodedCart.isEmpty) {
        return const {};
      }

      final Object? decodedCart = jsonDecode(encodedCart);
      if (decodedCart is! List<Object?>) {
        return const {};
      }

      final entries = decodedCart
          .map(StoredCartItem.tryFromJson)
          .whereType<StoredCartItem>()
          .map((item) => MapEntry(item.productId, item.quantity));

      return Map.unmodifiable(Map.fromEntries(entries));
    } on FormatException catch (error, stackTrace) {
      try {
        await prefs?.remove(_cartKey);
      } on Exception catch (removeError, removeStackTrace) {
        throw CartStorageException(
          message: 'Failed to clear invalid cart data',
          cause: removeError,
          stackTrace: removeStackTrace,
        );
      }

      if (prefs == null) {
        throw CartStorageException(
          message: 'Failed to decode cart data',
          cause: error,
          stackTrace: stackTrace,
        );
      }

      return const {};
    } on Exception catch (error, stackTrace) {
      throw CartStorageException(
        message: 'Failed to load cart data',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    try {
      final prefs = await _getPreferences();
      final storedItems = items
          .map(
            (item) => StoredCartItem(
              productId: item.product.id,
              quantity: item.quantity,
            ).toJson(),
          )
          .toList();

      await prefs.setString(_cartKey, jsonEncode(storedItems));
    } on Exception catch (error, stackTrace) {
      throw CartStorageException(
        message: 'Failed to save cart data',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final prefs = await _getPreferences();
      await prefs.remove(_cartKey);
    } on Exception catch (error, stackTrace) {
      throw CartStorageException(
        message: 'Failed to clear cart data',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
