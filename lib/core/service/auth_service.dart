import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/pages/sign_in_page.dart';
import '../constants/constants.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool _isRedirecting = false;

  static Future<void> logoutAndRedirect() async {
    if (_isRedirecting) return;
    _isRedirecting = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.token);

    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
            (route) => false,
      );
    }

    _isRedirecting = false;
  }
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.token);
  }
}