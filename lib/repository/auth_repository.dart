import 'dart:convert';
import '../data/exceptions/app_exceptions.dart';
import '../data/network/api_client.dart';
import '../data/response/api_response.dart';
import '../model/user/register_user_request.dart';
import '../model/user/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<User>> register(RegisterUserRequest request) async {
    try {
      final response = await _apiClient.post('/user/register', {
        'email': request.email,
        'password': request.password,
        'name': request.name,
      });

      // Parse user from nested JSON
      final user = User.fromJson(response);
      return ApiResponse.completed(user);
    } catch (e) {
      String message = 'An unexpected error occurred';

      // Check if it's ApiException and parse server message
      if (e is ApiException) {
        try {
          final body = jsonDecode(e.message ?? '{}');
          message = body['detail'] ?? message;
        } catch (_) {
          message = e.toString();
        }
      }

      return ApiResponse.error(message: message);
    }
  }

  /// 🔐 Login user
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/user/login', {
        'email': email,
        'password': password,
      });

      final user = User.fromApiJson(response);
      return ApiResponse.completed(user);
    } catch (e) {
      String message = 'Login failed. Please try again.';
      if (e is ApiException) {
        try {
          final body = jsonDecode(e.message ?? '{}');
          message = body['detail'] ?? message;
        } catch (_) {
          message = e.toString();
        }
      }
      return ApiResponse.error(message: message);
    }
  }
}
