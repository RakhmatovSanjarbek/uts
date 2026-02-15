import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WVideoLoading extends StatelessWidget {
  const WVideoLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Videolar yuklanmoqda...',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}