import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/core/utils/map_service.dart';
import 'package:uts_cargo/features/home/bloc/warehouse_bloc.dart';
import 'package:uts_cargo/features/home/info_bloc/info_bloc.dart';
import 'package:uts_cargo/features/profile/bloc/profile_bloc.dart';
import 'package:uts_cargo/features/home/widgets/w_basic_management.dart';
import 'package:uts_cargo/features/home/widgets/w_contact_bottom_sheet.dart';
import 'package:uts_cargo/features/home/widgets/w_home_toolbar.dart';
import 'package:uts_cargo/features/home/widgets/w_price_bottom_sheet.dart';
import 'package:uts_cargo/features/home/widgets/w_quick_access.dart';
import 'package:uts_cargo/features/home/widgets/w_warehouse.dart';
import 'package:uts_cargo/features/home/widgets/w_warehouse_bottom_sheet.dart';

import '../../../data/models/info_model/info_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InfoModel? _cachedInfo;
  String? _userId;
  // Ma'lumotlarni keshda saqlash uchun o'zgaruvchi
  dynamic _lastWarehouseData;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() {
    context.read<InfoBloc>().add(GetInfoEvent());
    context.read<WarehouseBloc>().add(GetArrivedGroupsEvent());
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: MultiBlocListener(
        listeners: [
          BlocListener<InfoBloc, InfoState>(
            listener: (context, state) {
              if (state is InfoSuccess) {
                setState(() => _cachedInfo = state.model);
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccess) {
                setState(() => _userId = state.model.userId);
              }
            },
          ),
          BlocListener<WarehouseBloc, WarehouseState>(
            listener: (context, state) {
              if (state is WarehouseError) {
                context.showSnackBarMessage(state.message);
              }
              // Ma'lumot kelganda uni keshga olamiz
              if (state is WarehouseLoaded) {
                setState(() => _lastWarehouseData = state.groups);
              }
            },
          ),
        ],
        child: BlocBuilder<WarehouseBloc, WarehouseState>(
          builder: (context, state) {
            // Agar loading bo'lsa va hali birinchi marta ma'lumot kelmagan bo'lsa
            if (state is WarehouseLoading && _lastWarehouseData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            // Agar ma'lumot bo'lsa (yoki Loaded yoki Refresh paytidagi Loading)
            if (_lastWarehouseData != null) {
              return _buildMainContent(context, _lastWarehouseData);
            }

            // Xatolik bo'lsa ham UI bo'sh qolmasligi uchun
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, dynamic groups) {
    // Ekranning umumiy balandligini olish
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        RefreshIndicator(
          // MUHIM: Toolbar ostidan chiqishi uchun (Toolbar taxminan 140px)
          displacement: 150,
          onRefresh: () async {
            _loadAllData();
            // Bloc stream orqali yangi holatni kutish
            await context.read<WarehouseBloc>().stream.firstWhere(
                  (state) => state is WarehouseLoaded || state is WarehouseError,
            );
          },
          child: SingleChildScrollView(
            // Doimo skroll bo'lishi uchun fizika
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              // Kontent kichik bo'lsa ham pastga tortish imkonini beradi
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 140.0), // Toolbar uchun joy
                  WQuickAccess(
                    onProhibitedPressed: () =>
                        Navigator.pushNamed(context, "/prohibited"),
                    onCalculatorPressed: () =>
                        Navigator.pushNamed(context, "/calculator"),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    AppStrings.orders,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(left: 16.0),
                  const SizedBox(height: 12.0),
                  WWarehouse(model: groups),
                  const SizedBox(height: 16.0),
                  WBasicManagement(
                    onVideoPressed: () => Navigator.pushNamed(context, "/video"),
                    onWarehousePressed: () => _showWarehouseBottomSheet(context),
                    onAboutPressed: () => Navigator.pushNamed(context, "/about"),
                    onPricePressed: () => _showPriceBottomSheet(context),
                    onContactPressed: () => _showContactBottomSheet(context),
                  ),
                  const SizedBox(height: 50.0), // Pastki qismda biroz joy
                ],
              ),
            ),
          ),
        ),
        // Toolbar har doim eng ustida
        WHomeToolbar(onLocationPressed: () {
          MapService.openSystemMap(lat: 41.334485, lng: 69.214603);
        },),
      ],
    );
  }

  void _showWarehouseBottomSheet(BuildContext context) {
    if (_cachedInfo == null || _userId == null) {
      context.showSnackBarMessage("Ma'lumotlar yuklanmoqda...");
      return;
    }
    final cleanId = _userId!.replaceFirst("UTS-", "");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WWarehouseBottomSheet(
        userId: cleanId,
        model: _cachedInfo!,
      ),
    );
  }

  void _showPriceBottomSheet(BuildContext context) {
    if (_cachedInfo == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WPriceBottomSheet(model: _cachedInfo!),
    );
  }

  void _showContactBottomSheet(BuildContext context) {
    if (_cachedInfo == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WContactBottomSheet(model: _cachedInfo!),
    );
  }
}