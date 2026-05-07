import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class WImagePicker extends StatelessWidget {
  final String title;
  final File? image;
  final VoidCallback onTap;

  const WImagePicker({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.screenColor,
          border: Border.all(
            color: image != null ? AppColors.mainColor : AppColors.grayColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: image != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Image.file(image!, fit: BoxFit.cover),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: AppColors.grayColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: AppColors.grayColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}