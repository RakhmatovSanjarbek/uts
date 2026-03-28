import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../../core/svg/app_svg.dart';

class WHomeToolbar extends StatelessWidget {
  final VoidCallback onLocationPressed;

  const WHomeToolbar({super.key, required this.onLocationPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      width: double.infinity,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onLocationPressed,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    AppSvg.icLocation,
                    colorFilter: ColorFilter.mode(
                      AppColors.mainColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.0,),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.pickupAddress,
                    style: TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    "Beruniy ko'chasi, 30",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 48.0,
            height: 48.0,
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SvgPicture.asset(
              AppSvg.icNotifications,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
