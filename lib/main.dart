import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/datasource/auth_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/calculator_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/chat_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/info_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/order_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/profile_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/video_remote_data_source.dart';
import 'package:uts_cargo/data/datasource/warehouse_remote_data_source.dart';
import 'package:uts_cargo/data/repositories/auth_repository_impl.dart';
import 'package:uts_cargo/data/repositories/calculator_repository_impl.dart';
import 'package:uts_cargo/data/repositories/chat_repository_impl.dart';
import 'package:uts_cargo/data/repositories/info_repositpry_impl.dart';
import 'package:uts_cargo/data/repositories/order_repository_impl.dart';
import 'package:uts_cargo/data/repositories/profile_repository_impl.dart';
import 'package:uts_cargo/data/repositories/video_repository_impl.dart';
import 'package:uts_cargo/data/repositories/warehouse_repository_impl.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/pages/enter_full_info_page.dart';
import 'package:uts_cargo/features/auth/pages/otp_verification_page.dart';
import 'package:uts_cargo/features/auth/pages/sign_in_page.dart';
import 'package:uts_cargo/features/calculator/bloc/calculator_bloc.dart';
import 'package:uts_cargo/features/calculator/pages/calculator_page.dart';
import 'package:uts_cargo/features/dashboard/dashboard_page.dart';
import 'package:uts_cargo/features/home/bloc/warehouse_bloc.dart';
import 'package:uts_cargo/features/home/info_bloc/info_bloc.dart';
import 'package:uts_cargo/features/home/pages/about_page.dart';
import 'package:uts_cargo/features/profile/bloc/easy_localization_bloc.dart'; // LanguageBloc nomi shunday deb taxmin qilindi
import 'package:uts_cargo/features/profile/bloc/profile_bloc.dart';
import 'package:uts_cargo/features/prohibited/pages/prohibited_page.dart';
import 'package:uts_cargo/features/splash/splash_page.dart';
import 'package:uts_cargo/features/support/bloc/chat_bloc.dart';
import 'package:uts_cargo/features/video_lesson/bloc/video_bloc.dart';

import 'core/constants/constants.dart';
import 'core/service/auth_service.dart';
import 'features/order/bloc/order_bloc.dart';
import 'features/video_lesson/pages/Video_page.dart';

void main() async {
  // 1. Flutter binding va EasyLocalization ni ishga tushirish
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final apiClient = ApiClient();

  // Data sources
  final authDataSource = AuthRemoteDataSource(apiClient);
  final profileDataSource = ProfileRemoteDataSource(apiClient);
  final orderDataSource = OrderRemoteDataSource(apiClient);
  final chatDataSource = ChatRemoteDataSource(apiClient);
  final videoDataSource = VideoRemoteDataSource(apiClient);
  final calculatorDataSource = CalculatorRemoteDataSource(apiClient);
  final warehouseDataSource = WarehouseRemoteDataSource(apiClient);
  final infoDataSource = InfoRemoteDataSource(apiClient);

  // Repositories
  final authRepository = AuthRepositoryImpl(authDataSource);
  final profileRepository = ProfileRepositoryImpl(profileDataSource);
  final orderRepository = OrderRepositoryImpl(orderDataSource);
  final chatRepository = ChatRepositoryImpl(chatDataSource);
  final videoRepository = VideoRepositoryImpl(videoDataSource);
  final calculatorRepository = CalculatorRepositoryImpl(calculatorDataSource);
  final warehouseRepository = WarehouseRepositoryImpl(warehouseDataSource);
  final infoRepository = InfoRepositoryImpl(infoDataSource);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uz'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('uz'),
      child: MyApp(
        authRepository: authRepository,
        profileRepository: profileRepository,
        orderRepository: orderRepository,
        chatRepository: chatRepository,
        videoRepository: videoRepository,
        calculatorRepository: calculatorRepository,
        warehouseRepository: warehouseRepository,
        infoRepository: infoRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ProfileRepositoryImpl profileRepository;
  final OrderRepositoryImpl orderRepository;
  final ChatRepositoryImpl chatRepository;
  final VideoRepositoryImpl videoRepository;
  final CalculatorRepositoryImpl calculatorRepository;
  final WarehouseRepositoryImpl warehouseRepository;
  final InfoRepositoryImpl infoRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.orderRepository,
    required this.chatRepository,
    required this.videoRepository,
    required this.calculatorRepository,
    required this.warehouseRepository,
    required this.profileRepository,
    required this.infoRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc()),
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => ProfileBloc(profileRepository)),
        BlocProvider(create: (_) => OrderBloc(orderRepository)),
        BlocProvider(create: (_) => ChatBloc(chatRepository)),
        BlocProvider(create: (_) => VideoBloc(videoRepository)),
        BlocProvider(create: (_) => CalculatorBloc(calculatorRepository)),
        BlocProvider(create: (_) => WarehouseBloc(warehouseRepository)),
        BlocProvider(create: (_) => InfoBloc(infoRepository)),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,

                initialRoute: "/splash",
                routes: {
                  "/splash": (context) => const SplashPage(),
                  "/login": (context) => const SignInPage(),
                  "/register": (context) {
                    final phone =
                        ModalRoute.of(context)!.settings.arguments as String;
                    return EnterFullInfoPage(phoneNumber: phone);
                  },
                  "/dashboard": (context) => const DashboardPage(),
                  "/verify": (context) {
                    final phone =
                        ModalRoute.of(context)!.settings.arguments as String;
                    return OtpVerificationPage(phoneNumber: phone);
                  },
                  "/prohibited": (context) => const ProhibitedPage(),
                  "/video": (context) => const VideoPage(),
                  "/calculator": (context) => const CalculatorPage(),
                  "/about": (context) => const AboutPage(),
                },
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.mainColor,
                  ),
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  fontFamily: Constants.exo,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
