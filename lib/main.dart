import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/dashboard/dashboard_page.dart';
import 'package:uts_cargo/features/splash/splash_page.dart';

import 'core/constants/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        fontFamily: Constants.exo,
      ),
      home: const SplashPage(),
    );
  }
}
