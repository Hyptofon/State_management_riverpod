class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;

  Product({
    required String id,
    required String name,
    required double price,
    required String category,
    required String image,
  }) : id = _validateRequiredText(id, 'Product id'),
       name = _validateRequiredText(name, 'Product name'),
       price = _validatePrice(price),
       category = _validateRequiredText(category, 'Product category'),
       image = _validateRequiredText(image, 'Product image');

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  static String _validateRequiredText(String value, String fieldName) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      throw ArgumentError.value(value, fieldName, '$fieldName cannot be empty');
    }
    return trimmedValue;
  }

  static double _validatePrice(double value) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(value, 'price', 'Price must be positive');
    }
    return value;
  }
}
