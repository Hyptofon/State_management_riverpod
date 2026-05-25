import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, int quantity = 1})
    : quantity = _validateQuantity(quantity);

  double get totalPrice => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  static int _validateQuantity(int value) {
    if (value < 1) {
      throw ArgumentError.value(value, 'quantity', 'Quantity must be positive');
    }
    return value;
  }
}
