import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/profile/presentation/widgets/w_user_info_txt.dart';

class WUserInfo extends StatelessWidget {
  const WUserInfo({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                "Shaxsiy ma'lumotlar",
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(color: AppColors.grayColor, height: 1),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WUserInfoTxt(
                infoName: "Foydalanuvchi-ID:",
                info: "RS 0032456",
                icon: AppSvg.icCopy,
                onPressed: () {},
              ),
              WUserInfoTxt(infoName: "JSHSHIR:", info: "42641478963426"),
            ],
          ),
          SizedBox(height: 16.0),
          WUserInfoTxt(
            infoName: "To'liq ism:",
            info: "RAHMATOV SANJARBEK",
            fonSize: 18.0,
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              WUserInfoTxt(infoName: "Pasport", info: "AC 3568459"),
              SizedBox(width: 48.0),
              WUserInfoTxt(infoName: "Tug'ulgan sana:", info: "21-06-2003"),
            ],
          ),
          SizedBox(height: 16.0),
          WUserInfoTxt(infoName: "Telefon:", info: "+998 (94) 485-66-03"),
        ],
      ),
    );
  }
}
