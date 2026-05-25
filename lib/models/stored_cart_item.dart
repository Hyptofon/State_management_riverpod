class StoredCartItem {
  final String productId;
  final int quantity;

  StoredCartItem({required String productId, required int quantity})
    : productId = _validateProductId(productId),
      quantity = _validateQuantity(quantity);

  static StoredCartItem? tryFromJson(Object? value) {
    if (value is! Map<String, Object?>) {
      return null;
    }

    final productId = value['productId'];
    final quantity = value['quantity'];

    if (productId is! String || quantity is! int) {
      return null;
    }

    try {
      return StoredCartItem(productId: productId, quantity: quantity);
    } on ArgumentError {
      return null;
    }
  }

  Map<String, Object> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }

  static String _validateProductId(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      throw ArgumentError.value(value, 'productId', 'Product id is empty');
    }
    return trimmedValue;
  }

  static int _validateQuantity(int value) {
    if (value < 1) {
      throw ArgumentError.value(value, 'quantity', 'Quantity must be positive');
    }
    return value;
  }
}
