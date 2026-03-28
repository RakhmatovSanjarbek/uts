import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import '../bloc/easy_localization_bloc.dart';

class WLanguageBottomSheet extends StatelessWidget {
  const WLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.screenColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16.0),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.grayColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            "select_lang".tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 20.0),

          _buildLangItem(context, "O'zbekcha", "🇺🇿", const Locale('uz')),
          _buildLangItem(context, "Русский", "🇷🇺", const Locale('ru')),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildLangItem(
    BuildContext context,
    String name,
    String flag,
    Locale locale,
  ) {
    final bool isSelected = context.locale == locale;

    return GestureDetector(
      onTap: () {
        context.read<LanguageBloc>().add(ChangeLanguage(context, locale));
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mainColor.withOpacity(0.1)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColors.mainColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: flag == "🇺🇿"
                  ? AssetImage("assets/images/uz_flag.png")
                  : AssetImage("assets/images/ru_flag.png"),
            ),
            const SizedBox(width: 16.0),
            Text(
              name,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.mainColor),
          ],
        ),
      ).paddingSymmetric(horizontal: 16.0),
    );
  }
}
