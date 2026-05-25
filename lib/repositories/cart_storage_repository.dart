import '../models/cart_item.dart';

abstract interface class CartStorageRepository {
  Future<Map<String, int>> loadCartQuantities();

  Future<void> saveCartItems(List<CartItem> items);

  Future<void> clearCart();
}
