import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/models/info_model/info_model.dart';

class WWarehouseBottomSheet extends StatelessWidget {
  final InfoModel model;
  final String userId;

  const WWarehouseBottomSheet({
    super.key,
    required this.userId,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        color: AppColors.screenColor,
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
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/images/china_flag.png",
                      ),
                      radius: 16.0,
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      "${AppStrings.china} (${AppStrings.avia})",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.warehouseAddress,
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 14.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                "收货人: UT-$userId\n电话: ${model.xitoyAvia.phone}\n安市: ${model.xitoyAvia.address} UT-$userId",
                          ),
                        );
                        context.showSnackBarMessage("Manzil nusxa olindi");
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(AppSvg.icCopy),
                    ),
                  ],
                ),
                Text(
                  "收货人: UT-$userId\n电话: ${model.xitoyAvia.phone}\n安市: ${model.xitoyAvia.address} UT-$userId",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 16.0),
                ).paddingOnly(right: 120.0),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/images/china_flag.png",
                      ),
                      radius: 16.0,
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      "${AppStrings.china} (${AppStrings.auto})",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.warehouseAddress,
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 14.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                            "收货人: A-$userId\n电话: ${model.xitoyAvto.phone}\n安市: ${model.xitoyAvto.address} A-$userId",
                          ),
                        );
                        context.showSnackBarMessage("Manzil nusxa olindi");
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(AppSvg.icCopy),
                    ),
                  ],
                ),
                Text(
                  "收货人: A-$userId\n电话: ${model.xitoyAvto.phone}\n安市: ${model.xitoyAvto.address} A-$userId",
                  style: TextStyle(color: AppColors.blackColor, fontSize: 16.0),
                ).paddingOnly(right: 120.0),
              ],
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
