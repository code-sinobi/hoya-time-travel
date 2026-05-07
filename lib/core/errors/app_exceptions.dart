/// Base class for all application exceptions
sealed class AppException implements Exception {
  const AppException(this.message, [this.innerError]);
  final String message;
  final Object? innerError;

  @override
  String toString() =>
      'AppException: $message${innerError != null ? ' ($innerError)' : ''}';
}

/// Thrown when network operations fail
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network error occurred',
    super.innerError,
  ]);
}

/// Thrown when authentication operations fail
class AuthException extends AppException {
  const AuthException([
    super.message = 'Authentication failed',
    super.innerError,
  ]);
}

/// Thrown when AI/Gemini operations fail
class AIException extends AppException {
  const AIException([super.message = 'AI service error', super.innerError]);
}

/// Thrown when database operations fail
class DataException extends AppException {
  const DataException([
    super.message = 'Data operation failed',
    super.innerError,
  ]);
}

/// Thrown when validation fails
class ValidationException extends AppException {
  const ValidationException([
    super.message = 'Validation failed',
    super.innerError,
  ]);
}
