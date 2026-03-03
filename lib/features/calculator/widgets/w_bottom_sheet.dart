import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/widgets/w_loading_button.dart';

class WBottomSheet extends StatefulWidget {
  const WBottomSheet({super.key});

  @override
  State<WBottomSheet> createState() => _WBottomSheetState();
}

class _WBottomSheetState extends State<WBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.0),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.grayColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Flexible(child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: AppColors.mainColor, width: 2.0),
                  ),
                  child: SvgPicture.asset(
                    AppSvg.icAddImage,
                    colorFilter: ColorFilter.mode(
                      AppColors.mainColor,
                      BlendMode.srcIn,
                    ),
                  ).paddingAll(24.0),
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Vazn"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text("Uzunlik"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ).paddingOnly(right: 4.0),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text("Kenglik"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 2.0),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          label: Text("Balandlik"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ).paddingOnly(left: 4.0),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16.0),
                SizedBox(height: 16.0),
              ],
            ),
          )),
          WLoadingButton(
            title: "Yuborish",
            isOnPressed: true,
            onPressed: () {},
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
