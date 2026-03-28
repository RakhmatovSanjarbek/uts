import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../core/svg/app_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: Column(
        children: [
          SizedBox(height: 64.0),
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
                AppStrings.aboutUs,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "UTS LOGISTIC",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: AppStrings.utsDescription1,
                      ),
                      TextSpan(
                        text: "MCHJ SADIKO EXPRESS",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: AppStrings.utsDescription2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Text(
                  AppStrings.whyUts,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  AppStrings.benefit1,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  AppStrings.benefit2,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  AppStrings.benefit3,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  AppStrings.benefit4,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                Text(
                  AppStrings.benefit5,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 14.0),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Text(AppStrings.partnershipGoal,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Text(AppStrings.missionStatement,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MCHJ "SADIKO EXPRESS"',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 11.0,
                      ),
                    ),
                    Text(
                      'UTSCARGOLOGISTIC@GMAIL.COM',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 20.0,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
