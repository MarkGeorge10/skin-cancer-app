import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

class RegisterUserRequest {
  final String email;
  final String password;
  final String name;

  RegisterUserRequest({
    required this.email,
    required this.password,
    required this.name,
  });

  factory RegisterUserRequest.fromJson(Map<String, dynamic> json) {
    return RegisterUserRequest(
      email: json['email'],
      password: json['password'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'name': name};
  }
}
