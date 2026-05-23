import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/core/service/fcm_service.dart';
import 'package:uts_cargo/core/network/api_client.dart';
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
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
    await _tryRefreshFcmToken();

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  Future<void> _tryRefreshFcmToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString(Constants.token);

      if (authToken == null || authToken.isEmpty) return;

      final fcmToken = await FcmService().getDeviceToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      final apiClient = ApiClient(token: authToken);
      await apiClient.patch('/api/auth/update-fcm-token/', body: {
        'fcm_token': fcmToken,
      });
    } catch (e) {

    }
    {

    }
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