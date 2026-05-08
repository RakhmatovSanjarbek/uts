// data/models/auth_model/auth_response.dart
import '../user_model/user_model.dart';

class AuthResponse {
  final String message;
  final String? token;
  final UserModel? user;
  final bool? success;

  AuthResponse({
    required this.message,
    this.token,
    this.user,
    this.success,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      success: json['success'],
    );
  }
}