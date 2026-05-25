class CartStorageException implements Exception {
  final String message;
  final Object cause;
  final StackTrace stackTrace;

  const CartStorageException({
    required this.message,
    required this.cause,
    required this.stackTrace,
  });

  @override
  String toString() {
    return 'CartStorageException: $message';
  }
}
