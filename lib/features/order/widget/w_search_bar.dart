import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WSearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;
  final String hintText;
  final TextEditingController? controller;

  const WSearchBar({
    super.key,
    required this.onSearch,
    this.onClear,
    this.hintText = 'Qidirish...',
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.grayColor200.withOpacity(0.5),
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.grayColor.withOpacity(0.5),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.grayColor,
            size: 22,
          ),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              controller?.clear();
              onSearch('');
              onClear?.call();
            },
            icon: Icon(
              Icons.close,
              color: AppColors.grayColor,
              size: 20,
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}