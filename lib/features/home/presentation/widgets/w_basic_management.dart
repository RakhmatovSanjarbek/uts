import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/presentation/widgets/w_action_button.dart';

import '../../../../core/svg/app_svg.dart';

class WBasicManagement extends StatelessWidget {
  final VoidCallback onVideoPressed;
  const WBasicManagement({super.key, required this.onVideoPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.44,
                    height: 72.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ball",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 40.0,
                          height: 40.0,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: SvgPicture.asset(
                            AppSvg.icStar,
                            colorFilter: ColorFilter.mode(
                              AppColors.whiteColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.44,
                    height: 60.0,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [AppColors.btn1Color, AppColors.btn2Color],
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "Omborlar manzili",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onVideoPressed,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.44,
                  height: 140.0,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [AppColors.btn1Color, AppColors.btn2Color],
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: AppColors.whiteColor,
                                width: 2.0,
                              ),
                            ),
                            child: SvgPicture.asset(
                              AppSvg.icVideo,
                              colorFilter: ColorFilter.mode(
                                AppColors.whiteColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              "Video darsliklar",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14.0,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ).paddingOnly(left: 8.0, right: 8.0, top: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "assets/images/pinduoduo_logo.png",
                              width: MediaQuery.of(context).size.width * 0.12,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "assets/images/taobao_logo.png",
                              width: MediaQuery.of(context).size.width * 0.12,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "assets/images/alibaba_logo.png",
                              width: MediaQuery.of(context).size.width * 0.12,
                            ),
                          ),
                        ],
                      ).paddingOnly(bottom: 8.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WActionButton(
                title: 'Kompaniya haqida',
                svgPath: AppSvg.icCompany,
              ),
              WActionButton(title: 'Kontaktlar', svgPath: AppSvg.icContact),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WActionButton(
                title: 'Xizmat, narx, muddat',
                svgPath: AppSvg.icMoney,
                fonSize: 14.0,
              ),
              WActionButton(title: 'Kodsiz tovarlar', svgPath: AppSvg.icQrCode),
            ],
          ),
          SizedBox(height: 24.0),

          SizedBox(
            width: double.infinity,
            height: 60.0,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: AppColors.whiteColor,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                "QO'SHIMCHA PASPURT",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
