import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/widgets/w_basic_management.dart';
import 'package:uts_cargo/features/home/widgets/w_home_toolbar.dart';
import 'package:uts_cargo/features/home/widgets/w_quick_access.dart';
import 'package:uts_cargo/features/home/widgets/w_warehouse_bottom_sheet.dart';

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
                  onCalculatorPressed: () {
                    Navigator.pushNamed(context, "/calculator");
                  },
                ),
                WBasicManagement(
                  onVideoPressed: () {
                    Navigator.pushNamed(context, "/video");
                  },
                  onWarehousePressed: () => _showWarehouseBottomSheet(context),
                  onAboutPressed: () {
                    Navigator.pushNamed(context, "/about");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWarehouseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const WWarehouseBottomSheet(userId: "UTS-003");
      },
    );
  }
}
