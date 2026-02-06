import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/datasources/auth_remote_data_source.dart';
import 'package:uts_cargo/data/repositories/auth_repository_impl.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/pages/enter_full_info_page.dart';
import 'package:uts_cargo/features/auth/pages/otp_verification_page.dart';
import 'package:uts_cargo/features/auth/pages/sign_in_page.dart';
import 'package:uts_cargo/features/dashboard/dashboard_page.dart';
import 'package:uts_cargo/features/splash/splash_page.dart';

import 'core/constants/constants.dart';

void main() {
  final apiClient = ApiClient();
  final authDataSource = AuthRemoteDataSource(apiClient);
  final authRepository = AuthRepositoryImpl(authDataSource);
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> AuthBloc(authRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        routes: {
          "/splash": (context) => SplashPage(),
          "/login": (context) => SignInPage(),
          "/register": (context) {
            final phone = ModalRoute.of(context)!.settings.arguments as String;
            return EnterFullInfoPage(phoneNumber: phone);
          },
          "/dashboard": (context) => DashboardPage(),
          "/verify": (context) {
            final phone = ModalRoute.of(context)!.settings.arguments as String;
            return OtpVerificationPage(phoneNumber: phone);
          },
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          fontFamily: Constants.exo,
        ),
      ),
    );
  }
}
