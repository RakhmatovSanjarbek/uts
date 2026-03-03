import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/features/calculator/widgets/w_bottom_sheet.dart';

import '../../../core/svg/app_svg.dart';
import '../../../core/theme/app_colors.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: Column(
        children: [
          SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      AppSvg.icBack,
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                  Text(
                    "Kalkulyator",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  _showBottomSheet(context);
                },
                icon: SvgPicture.asset(AppSvg.icAdd),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const WBottomSheet();
      },
    );
  }
}
