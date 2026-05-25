class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
