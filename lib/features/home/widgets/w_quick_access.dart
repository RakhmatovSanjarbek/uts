import 'package:flutter/material.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/features/home/widgets/w_quick_button.dart';

import '../../../../core/svg/app_svg.dart';

class WQuickAccess extends StatelessWidget {
  final VoidCallback onProhibitedPressed;
  final VoidCallback onCalculatorPressed;

  const WQuickAccess({
    super.key,
    required this.onProhibitedPressed,
    required this.onCalculatorPressed,
  });

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
              title: AppStrings.prohibitedItems
            ),
          ),
          GestureDetector(
            onTap: onCalculatorPressed,
            child: WQuickButton(
              icon: AppSvg.icCalculator,
              title: AppStrings.calculatorGoods,
            ),
          ),
          GestureDetector(
            child: WQuickButton(icon: AppSvg.icPlane, title: AppStrings.delivery, isActive: false,),
          ),
        ],
      ),
    );
  }
}
