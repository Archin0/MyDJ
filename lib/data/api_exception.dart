class ApiException implements Exception {
  ApiException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
