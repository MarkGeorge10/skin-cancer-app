class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class ApiException extends AppException {
  final int? statusCode;
  ApiException(super.message, {this.statusCode});
}

class NoInternetException extends AppException {
  NoInternetException() : super('No internet connection');
}
// Add more as needed (e.g., TimeoutException)