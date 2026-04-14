class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException() : super('Problems with the Internet connection');
}

class BadRequestException extends ApiException {
  BadRequestException([String message = 'Invalid request parameters'])
      : super(message, 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(
      [String message = 'Session expired. Please log in again.'])
      : super(message, 401);
}

class ServerSideException extends ApiException {
  ServerSideException([String message = 'Internal server error'])
      : super(message, 500);
}

