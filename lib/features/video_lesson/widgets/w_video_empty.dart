import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

class WVideoEmpty extends StatelessWidget {
  const WVideoEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset(
              'assets/lottie/empty.json',
              animate: true,
              repeat: true,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hozircha videolar mavjud emas',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tez orada yangi darslar qo\'shiladi',
            style: TextStyle(
              color: AppColors.whiteColor.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}