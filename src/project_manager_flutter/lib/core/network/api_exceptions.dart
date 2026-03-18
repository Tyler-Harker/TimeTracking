class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;

  factory ApiException.fromResponse(int statusCode, dynamic data) {
    if (data is Map<String, dynamic>) {
      if (statusCode == 422 && data.containsKey('errors')) {
        return ValidationApiException(
          message: data['error'] as String? ?? 'Validation failed',
          statusCode: statusCode,
          fieldErrors: (data['errors'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
              key,
              (value as List).map((e) => e.toString()).toList(),
            ),
          ),
        );
      }
      return ApiException(
        message: data['error'] as String? ?? 'An unexpected error occurred',
        statusCode: statusCode,
      );
    }
    return ApiException(
      message: 'An unexpected error occurred',
      statusCode: statusCode,
    );
  }
}

class ValidationApiException extends ApiException {
  final Map<String, List<String>> fieldErrors;

  const ValidationApiException({
    required super.message,
    super.statusCode,
    required this.fieldErrors,
  });

  String? firstErrorFor(String field) {
    // Try exact match first, then case-insensitive
    final errors = fieldErrors[field] ??
        fieldErrors[field[0].toUpperCase() + field.substring(1)];
    return errors?.firstOrNull;
  }

  String get allErrors {
    return fieldErrors.values.expand((e) => e).join('\n');
  }
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Unauthorized'})
      : super(statusCode: 401);
}

class NetworkException extends ApiException {
  const NetworkException({super.message = 'Network error. Please check your connection.'});
}
