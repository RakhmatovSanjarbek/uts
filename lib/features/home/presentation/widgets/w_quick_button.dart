import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/svg/app_svg.dart';
import '../../../../core/theme/app_colors.dart';

class WQuickButton extends StatelessWidget {
  final String icon;
  final String title;

  const WQuickButton({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.29,
      height: 120.0,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.mainColor, width: 1.5),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              style: TextStyle(color: AppColors.blackColor, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
