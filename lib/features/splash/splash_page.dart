import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../core/constants/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.token) ?? "";

    if (!mounted) return;

    if (token.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/dashboard",
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Stack(
        children: [Center(child: Image.asset("assets/images/app_logo.jpg"))],
      ),
    );
  }
}
