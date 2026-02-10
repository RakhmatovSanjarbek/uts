import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WUserInfoTxt extends StatelessWidget {
  final String infoName;
  final String info;
  final String? icon;
  final VoidCallback? onPressed;
  final double fonSize;

  const WUserInfoTxt({
    super.key,
    required this.infoName,
    required this.info,
    this.icon,
    this.onPressed,
    this.fonSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              infoName,
              style: TextStyle(color: AppColors.grayColor, fontSize: 14.0),
            ),
            Text(
              info,
              style: TextStyle(color: AppColors.blackColor, fontSize: fonSize),
            ),
          ],
        ),
        icon != null
            ? IconButton(
                onPressed: onPressed,
                icon: SvgPicture.asset(
                  icon!,
                  width: 24.0,
                  height: 24.0,
                  colorFilter: ColorFilter.mode(
                    AppColors.mainColor,
                    BlendMode.srcIn,
                  ),
                ),
              ).paddingOnly(top: 16.0)
            : Container(),
      ],
    );
  }
}
