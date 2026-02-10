import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/datasource/auth_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/chat_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/order_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/profile_remote_data_source.dart';
import 'package:uts_cargo/data/repositories/auth_repository_impl.dart';
import 'package:uts_cargo/data/repositories/chat_repository_impl.dart';
import 'package:uts_cargo/data/repositories/order_repository_impl.dart';
import 'package:uts_cargo/data/repositories/profile_repository_impl.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/pages/enter_full_info_page.dart';
import 'package:uts_cargo/features/auth/pages/otp_verification_page.dart';
import 'package:uts_cargo/features/auth/pages/sign_in_page.dart';
import 'package:uts_cargo/features/dashboard/dashboard_page.dart';
import 'package:uts_cargo/features/profile/bloc/profile_bloc.dart';
import 'package:uts_cargo/features/splash/splash_page.dart';
import 'package:uts_cargo/features/support/bloc/chat_bloc.dart';

import 'core/constants/constants.dart';
import 'features/order/bloc/order_bloc.dart';

void main() {
  final apiClient = ApiClient();
  final authDataSource = AuthRemoteDataSource(apiClient);
  final authRepository = AuthRepositoryImpl(authDataSource);

  final userDataSource = ProfileRemoteDataSource(apiClient);
  final userRepository = ProfileRepositoryImpl(userDataSource);

  final orderDataSource = OrderRemoteDataSource(apiClient);
  final orderRepository = OrderRepositoryImpl(orderDataSource);

  final chatDataSource = ChatRemoteDataSource(apiClient);
  final chatRepository = ChatRepositoryImpl(chatDataSource);
  runApp(
    MyApp(
      authRepository: authRepository,
      userRepository: userRepository,
      orderRepository: orderRepository,
      chatRepository: chatRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ProfileRepositoryImpl userRepository;
  final OrderRepositoryImpl orderRepository;
  final ChatRepositoryImpl chatRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.userRepository,
    required this.orderRepository,
    required this.chatRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => ProfileBloc(userRepository)),
        BlocProvider(create: (_) => OrderBloc(orderRepository)),
        BlocProvider(create: (_) => ChatBloc(chatRepository)),
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
