abstract final class AppStrings {
  // App
  static const appTitle = 'Riverpod Shop';

  // Products screen
  static const productsTitle = 'Products';
  static const searchProducts = 'Search products';
  static const allCategories = 'All';
  static const noProductsFound = 'No products found';
  static const addToCart = 'Add to Cart';

  // Cart screen
  static const cartTitle = 'Shopping Cart';
  static const cartEmpty = 'Cart is empty';

  // Checkout summary
  static const itemsLabel = 'Items';
  static const totalLabel = 'Total';
  static const checkoutButton = 'Checkout';

  // Cart item
  static String subtotal(String price) => 'Subtotal: $price';

  // SnackBar messages
  static const addedToCart = 'Added to cart';
  static const removedFromCart = 'Removed from cart';
  static const cartCleared = 'Cart cleared';
  static const checkoutReady = 'Order is ready for checkout';

  // Tooltips
  static const openCartTooltip = 'Open cart';
  static const clearCartTooltip = 'Clear cart';
  static const clearSearchTooltip = 'Clear search';
  static const removeItemTooltip = 'Remove item';
  static const decreaseQuantityTooltip = 'Decrease quantity';
  static const increaseQuantityTooltip = 'Increase quantity';
}
