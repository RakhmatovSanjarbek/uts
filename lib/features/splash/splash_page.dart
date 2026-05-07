import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

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
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
        (route) => false,
      );
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
