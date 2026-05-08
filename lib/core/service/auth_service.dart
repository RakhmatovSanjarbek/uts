// core/service/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/constants/constants.dart';

class AuthService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.token, token);
    print("✅ Token saved: $token"); // Debug uchun
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.token);
    print("🔑 Token retrieved: ${token != null ? "Yes ($token)" : "No"}"); // Debug uchun
    return token;
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.token);
    print("🗑️ Token cleared"); // Debug uchun
  }

  static Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}