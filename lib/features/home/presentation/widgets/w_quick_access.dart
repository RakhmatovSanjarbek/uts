import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

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
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.29,
              height: 120.0,
              padding: EdgeInsets.all(16.0),
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
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SvgPicture.asset(
                      AppSvg.icWarning,
                      colorFilter: ColorFilter.mode(
                        AppColors.whiteColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Taqiqlangan buyumlar",
                      maxLines: 2,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.29,
            height: 120.0,
            padding: EdgeInsets.all(16.0),
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
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SvgPicture.asset(
                    AppSvg.icId,
                    colorFilter: ColorFilter.mode(
                      AppColors.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "ID olish yo'riqnoma",
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.29,
            height: 120.0,
            padding: EdgeInsets.all(16.0),
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
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SvgPicture.asset(
                    AppSvg.icPlane,
                    colorFilter: ColorFilter.mode(
                      AppColors.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Yetkazib berish",
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
