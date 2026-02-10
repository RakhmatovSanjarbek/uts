import 'package:flutter/material.dart';
import 'package:uts_cargo/features/home/presentation/widgets/w_quick_button.dart';

import '../../../../core/svg/app_svg.dart';

class WQuickAccess extends StatelessWidget {
  final VoidCallback onProhibitedPressed;

  const WQuickAccess({super.key, required this.onProhibitedPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onProhibitedPressed,
            child: WQuickButton(
              icon: AppSvg.icWarning,
              title: "Taqiqlangan burumlar",
            ),
          ),
          GestureDetector(
            child: WQuickButton(
              icon: AppSvg.icCalculator,
              title: "Kalkulyator (tovat)",
            ),
          ),
          GestureDetector(
            child: WQuickButton(icon: AppSvg.icPlane, title: "Yetkazib berosh"),
          ),
        ],
      ),
    );
  }
}
