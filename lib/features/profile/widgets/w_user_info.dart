import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/models/user_model/user_model.dart';
import 'package:uts_cargo/features/profile/widgets/w_user_info_txt.dart';

class WUserInfo extends StatelessWidget {
  final VoidCallback onPressedEditButton;
  final VoidCallback onPressed;
  final bool isLoading;
  final UserModel model;

  const WUserInfo({
    super.key,
    required this.model,
    this.isLoading = false,
    required this.onPressed,
    required this.onPressedEditButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
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
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppSvg.icBadge,
                          colorFilter: ColorFilter.mode(
                            AppColors.mainColor,
                            BlendMode.srcIn,
                          ),
                          width: 24.0,
                          height: 24.0,
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          AppStrings.personalInfo,
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: onPressedEditButton,
                      icon: Icon(Icons.edit, color: AppColors.mainColor),
                    ),
                  ],
                ),
                Divider(color: AppColors.grayColor, height: 1),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WUserInfoTxt(
                      infoName: "${AppStrings.id}:",
                      info: model.userId,
                      icon: AppSvg.icCopy,
                      onPressed: onPressed,
                    ),
                    WUserInfoTxt(
                      infoName: "${AppStrings.pinfl}:",
                      info: model.jshshir,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                WUserInfoTxt(
                  infoName: AppStrings.fullName,
                  info: "${model.firstName} ${model.lastName}",
                  fonSize: 18.0,
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    WUserInfoTxt(
                      infoName: "${AppStrings.passport}:",
                      info: _formatPassport(model.passportSeries),
                    ),
                    SizedBox(width: 48.0),
                    WUserInfoTxt(
                      infoName: AppStrings.birthDate,
                      info: _formatBirthDate(model.birthDate),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                WUserInfoTxt(
                  infoName: AppStrings.phone,
                  info: _formatPhoneNumber(model.phone),
                ),
              ],
            ),
    );
  }

  String _formatBirthDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;

    final year = parts[0];
    final month = parts[1];
    final day = parts[2];

    return '$day-$month-$year';
  }

  String _formatPhoneNumber(String phone) {
    var phones = "+$phone";

    final code = phones.substring(0, 4);
    final operator = phones.substring(4, 6);
    final part1 = phones.substring(6, 9);
    final part2 = phones.substring(9, 11);
    final part3 = phones.substring(11, 13);

    return '$code ($operator) $part1-$part2-$part3';
  }

  String _formatPassport(String passport) {
    if (passport.length < 3) return passport;

    final series = passport.substring(0, 2);
    final number = passport.substring(2);

    return '$series $number';
  }
}
