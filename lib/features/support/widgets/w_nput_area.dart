import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uts_cargo/core/string/app_string.dart';

import '../../../core/svg/app_svg.dart';
import '../../../core/theme/app_colors.dart';

class WInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;

  const WInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(color: AppColors.whiteColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onPickImage,
            icon: SvgPicture.asset(
              AppSvg.icFile,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
              height: 24,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.grayColor200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: AppStrings.writeMessage,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: AppColors.mainColor,
            radius: 22,
            child: IconButton(
              onPressed: onSend,
              icon: SvgPicture.asset(
                AppSvg.icSend,
                colorFilter: ColorFilter.mode(
                  AppColors.whiteColor,
                  BlendMode.srcIn,
                ),
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
