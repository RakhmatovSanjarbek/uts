import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/core/service/fcm_service.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/core/widgets/no_internet_sheet.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/version/bloc/version_bloc.dart';
import 'package:uts_cargo/features/version/widgets/update_dialog.dart';

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
    final result = await Connectivity().checkConnectivity();
    final hasInternet = result.any((r) => r != ConnectivityResult.none);

    if (!mounted) return;

    if (!hasInternet) {
      await _waitForInternet();
      if (!mounted) return;
    }
    context.read<VersionBloc>().add(const CheckAppVersionEvent());
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
    await _tryRefreshFcmToken();
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    final versionState = context.read<VersionBloc>().state;
    if (versionState is VersionUpdateRequired) return;

    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  Future<void> _waitForInternet() async {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const NoInternetSheet(),
    );

    await for (final result in Connectivity().onConnectivityChanged) {
      final hasInternet = result.any((r) => r != ConnectivityResult.none);
      if (hasInternet) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        break;
      }
    }
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VersionBloc, VersionState>(
      listener: (context, state) {
        if (state is VersionUpdateRequired) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => UpdateDialog(model: state.model),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        body: Center(
          child: Image.asset("assets/images/app_logo.png"),
        ),
      ),
    );
  }
}