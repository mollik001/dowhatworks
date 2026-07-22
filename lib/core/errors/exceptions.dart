class AppException implements Exception {
  final String message;
  final dynamic cause;

  AppException(this.message, [this.cause]);

  @override
  String toString() => 'AppException: $message';
}
