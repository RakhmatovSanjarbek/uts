import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/features/home/pages/home_page.dart';
import 'package:uts_cargo/features/profile/pages/profile_page.dart';
import 'package:uts_cargo/features/support/pages/support_chat_page.dart';

import '../../core/constants/constants.dart';
import '../../core/svg/app_svg.dart';
import '../../core/theme/app_colors.dart';
import '../order/pages/order_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomePage(),
    const OrderPage(),
    const SupportChatPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: IndexedStack(
        key: ValueKey(Localizations.localeOf(context).languageCode),
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.whiteColor,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.grayColor,
        selectedLabelStyle: TextStyle(
          color: AppColors.mainColor,
          fontFamily: Constants.exo,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          color: AppColors.grayColor,
          fontFamily: Constants.exo,
          fontWeight: FontWeight.bold,
        ),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppSvg.icHome,
              colorFilter: ColorFilter.mode(
                AppColors.grayColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              AppSvg.icActiveHome,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
            label: AppStrings.main,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppSvg.icBox,
              colorFilter: ColorFilter.mode(
                AppColors.grayColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              AppSvg.icActiveBox,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
            label: AppStrings.order,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppSvg.icMessage,
              colorFilter: ColorFilter.mode(
                AppColors.grayColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              AppSvg.icActiveMessage,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
            label: AppStrings.help,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppSvg.icProfile,
              colorFilter: ColorFilter.mode(
                AppColors.grayColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              AppSvg.icActiveProfile,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
