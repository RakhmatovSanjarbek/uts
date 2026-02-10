import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WActionButton extends StatelessWidget {
  final String svgPath;
  final String buttonName;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color txtColor;

  const WActionButton({
    super.key,
    required this.svgPath,
    required this.buttonName,
    required this.onPressed,
    this.iconColor = AppColors.mainColor,
    this.txtColor = AppColors.blackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64.0,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0),
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
        children: [
          Row(
            children: [
              SvgPicture.asset(
                svgPath,
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              SizedBox(width: 16.0),
              Text(
                buttonName,
                style: TextStyle(color: txtColor, fontSize: 18.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
