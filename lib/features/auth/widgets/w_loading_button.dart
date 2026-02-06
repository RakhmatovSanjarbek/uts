import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WLoadingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;
  final String title;
  final bool isOnPressed;
  final bool isLoading;

  const WLoadingButton({
    super.key,
    this.marginLeft = 16.0,
    this.marginRight = 16.0,
    this.marginTop = 16.0,
    this.marginBottom = 16.0,
    required this.title,
    required this.isOnPressed,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.0,
      margin: EdgeInsets.only(
        left: marginLeft,
        right: marginRight,
        top: marginTop,
        bottom: marginBottom,
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56.0,
            child: ElevatedButton(
              onPressed: isOnPressed ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOnPressed
                    ? AppColors.mainColor
                    : AppColors.grayColor,
                foregroundColor: isOnPressed
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: Colors.black12),
                ),
              ),
              child: Text(
                isLoading ? "" : title,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.whiteColor),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
