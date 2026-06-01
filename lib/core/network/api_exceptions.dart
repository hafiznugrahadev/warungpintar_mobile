class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Unauthorized'})
      : super(statusCode: 401);
}

class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Not found'})
      : super(statusCode: 404);
}

class ValidationException extends ApiException {
  final List<Map<String, String>> details;

  const ValidationException({
    required super.message,
    this.details = const [],
  }) : super(statusCode: 422);
}

class NetworkException extends ApiException {
  const NetworkException(
      {super.message = 'Network error. Check your connection.'});
}

class ServerException extends ApiException {
  const ServerException(
      {super.message = 'Server error. Please try again.'})
      : super(statusCode: 500);
}
