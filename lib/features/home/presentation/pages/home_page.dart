import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/presentation/widgets/w_basic_management.dart';
import 'package:uts_cargo/features/home/presentation/widgets/w_home_toolbar.dart';
import 'package:uts_cargo/features/home/presentation/widgets/w_quick_access.dart';
import 'package:uts_cargo/features/prohibited/pages/prohibited_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: Stack(
        children: [
          WHomeToolbar(),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 140.0),
                WQuickAccess(
                  onProhibitedPressed: () {
                    Navigator.pushNamed(context, "/prohibited");
                  },
                ),
                WBasicManagement(
                  onVideoPressed: () {
                    Navigator.pushNamed(context, "/video");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
