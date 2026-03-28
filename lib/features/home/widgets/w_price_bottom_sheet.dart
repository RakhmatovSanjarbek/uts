import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/models/info_model/info_model.dart';

class WPriceBottomSheet extends StatelessWidget {
  final InfoModel model;

  const WPriceBottomSheet({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.screenColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.0),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.grayColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "assets/images/china.png",
                      width: 64.0,
                      height: 44.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.china,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppSvg.icPlane,
                            width: 20.0,
                            height: 20.0,
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            AppStrings.avia,
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${model.xitoyAvia.price}\$",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: AppColors.grayColor200,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      model.xitoyAvia.term,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16.0),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "assets/images/china.png",
                      width: 64.0,
                      height: 44.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.china,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppSvg.icCar,
                            width: 20.0,
                            height: 20.0,
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            AppStrings.auto,
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${model.xitoyAvto.price}\$",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: AppColors.grayColor200,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      model.xitoyAvto.term,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16.0),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }
}
