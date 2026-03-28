import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/profile/widgets/w_user_info_txt.dart';

class WRelativePassportInfo extends StatelessWidget {
  final VoidCallback onPressedDeleted;
  final bool isLoading;
  final String fullName;
  final String passport;
  final String personalNumber;
  final String brithDay;
  final String phone;

  const WRelativePassportInfo({
    super.key,
    this.isLoading = false,
    required this.onPressedDeleted,
    required this.fullName,
    required this.passport,
    required this.personalNumber,
    required this.brithDay,
    required this.phone,
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
                    WUserInfoTxt(
                      infoName: "${AppStrings.pinfl}:",
                      info: personalNumber,
                    ),
                    IconButton(
                      onPressed: onPressedDeleted,
                      icon: Icon(
                        CupertinoIcons.delete,
                        color: AppColors.redColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                WUserInfoTxt(
                  infoName: AppStrings.fullName,
                  info: fullName,
                  fonSize: 18.0,
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    WUserInfoTxt(
                      infoName: "${AppStrings.passport}:",
                      info: _formatPassport(passport),
                    ),
                    SizedBox(width: 48.0),
                    WUserInfoTxt(
                      infoName: AppStrings.birthDate,
                      info: _formatBirthDate(brithDay),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                WUserInfoTxt(
                  infoName: AppStrings.phone,
                  info: _formatPhoneNumber(phone),
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

  String _formatPassport(String passport) {
    if (passport.length < 3) return passport;

    final series = passport.substring(0, 2);
    final number = passport.substring(2);

    return '$series $number';
  }

  String _formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.length != 9) return phone;
    final operator = cleanPhone.substring(0, 2);
    final part1 = cleanPhone.substring(2, 5);
    final part2 = cleanPhone.substring(5, 7);
    final part3 = cleanPhone.substring(7, 9);

    return '+998 ($operator) $part1-$part2-$part3';
  }
}
