class CustomTimeoutException implements Exception {
  final String message;

  const CustomTimeoutException(this.message);

  @override
  String toString() => 'CustomTimeoutException: $message';
}
