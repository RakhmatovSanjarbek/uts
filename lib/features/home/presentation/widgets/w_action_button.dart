import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/svg/app_svg.dart';
import '../../../../core/theme/app_colors.dart';

class WActionButton extends StatelessWidget {
  final String title;
  final String svgPath;
  final double fonSize;
  final double? width;

  const WActionButton({
    super.key,
    required this.title,
    required this.svgPath,
    this.fonSize = 14.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonWidth =
        width ?? MediaQuery.sizeOf(context).width * 0.44;
    return Container(
      width: buttonWidth,
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
          Container(
            width: 40.0,
            height: 40.0,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: AppColors.blackColor, fontSize: fonSize),
            ),
          ),
        ],
      ),
    );
  }
}
