// features/splash/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Auth statusni tekshirish
    context.read<AuthBloc>().add(CheckAuthStatusEvent());

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final authState = context.read<AuthBloc>().state;

    // Har doim Dashboardga o'tamiz
    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Image.asset("assets/images/app_logo.jpg"),
      ),
    );
  }
}