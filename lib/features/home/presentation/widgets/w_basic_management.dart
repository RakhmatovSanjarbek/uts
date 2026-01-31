import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/presentation/widgets/w_action_button.dart';

import '../../../../core/svg/app_svg.dart';

class WBasicManagement extends StatefulWidget {
  const WBasicManagement({super.key});

  @override
  State<WBasicManagement> createState() => _WBasicManagementState();
}

class _WBasicManagementState extends State<WBasicManagement> {
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
                    alignment: Alignment.center,
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
                        Expanded(
                          child: Text(
                            "Omborlar manzili",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          AppSvg.icArrow,
                          colorFilter: ColorFilter.mode(
                            AppColors.mainColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.44,
                height: 140.0,
                padding: EdgeInsets.all(16.0),
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
                child: Stack(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                            AppSvg.icVideo,
                            colorFilter: ColorFilter.mode(
                              AppColors.whiteColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0,),
                        Expanded(
                          child: Text(
                            "Video darsliklar",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            AppSvg.icArrow,
                            colorFilter: ColorFilter.mode(
                              AppColors.mainColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WActionButton(title: 'Kompaniya haqida', svgPath: AppSvg.icCompany,),
              WActionButton(title: 'Kontaktlar', svgPath: AppSvg.icContact,),
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WActionButton(title: 'Xizmat, narx, muddat', svgPath: AppSvg.icMoney, fonSize: 14.0,),
              WActionButton(title: 'Kodsiz tovarlar', svgPath: AppSvg.icQrCode,),
            ],
          ),
          SizedBox(height: 8.0,),
          WActionButton(title: "Kalkulator (tovar)", svgPath: AppSvg.icCalculator, width: double.infinity, fonSize: 16.0,)
        ],
      ),
    );
  }
}
