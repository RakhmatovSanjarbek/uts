import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static bool _isRedirecting = false;

  static void redirectToLogin() {
    if (_isRedirecting) return;
    _isRedirecting = true;

    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(ctx).pushNamedAndRemoveUntil(
          '/login',
              (route) => false,
        );
        _isRedirecting = false;
      });
    } else {
      _isRedirecting = false;
    }
  }

  static Future<void> clearToken() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.token);
  }
}