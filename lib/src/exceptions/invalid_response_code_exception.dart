class InvalidResponseCodeException implements Exception {
  final int code;

  const InvalidResponseCodeException(this.code);
}
