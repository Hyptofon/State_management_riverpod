import 'cart_item.dart';

class CartState {
  final List<CartItem> _items;
  final bool isLoading;

  CartState({List<CartItem> items = const [], this.isLoading = false})
    : _items = List.unmodifiable(items);

  List<CartItem> get items => _items;

  bool get isEmpty => _items.isEmpty;

  int get totalQuantity {
    return _items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.fold<double>(0, (sum, item) => sum + item.totalPrice);
  }

  CartState copyWith({List<CartItem>? items, bool? isLoading}) {
    return CartState(
      items: items ?? _items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
