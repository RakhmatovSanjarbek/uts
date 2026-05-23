import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

extension SnackbarExtension on BuildContext {
  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: AppColors.mainColor,
      ),
    );
  }
}
