import 'package:skin_cancer_app/data/exceptions/app_exceptions.dart';

enum Status { loading, empty, completed, error }

class ApiResponse<T> {
  final Status status;
  final T? data;
  final String? message;
  final Exception? exception;

  ApiResponse.loading() : this._(Status.loading);

  ApiResponse.empty({String? message}) : this._(Status.empty, message: message);

  ApiResponse.completed(T data) : this._(Status.completed, data: data);

  ApiResponse.error({String? message, AppException? exception})
      : this._(Status.error, message: message, exception: exception);

  ApiResponse._(this.status, {this.data, this.message, this.exception});
}