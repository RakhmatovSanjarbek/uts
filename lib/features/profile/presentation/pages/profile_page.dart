import 'package:flutter/material.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/profile/presentation/widgets/w_action_button.dart';
import 'package:uts_cargo/features/profile/presentation/widgets/w_user_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.0),
            Container(
              margin: EdgeInsets.only(left: 16.0),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            WUserInfo(),
            SizedBox(height: 16.0),
            WActionButton(
              svgPath: AppSvg.icLocation,
              buttonName: "Topshirish punkiti",
              onPressed: () {},
            ),
            SizedBox(height: 16.0),
            WActionButton(
              svgPath: AppSvg.icSettings,
              buttonName: "Sozlamalar",
              onPressed: () {},
            ),
            SizedBox(height: 16.0),
            WActionButton(
              svgPath: AppSvg.icLanguage,
              buttonName: "Til (o'zbek)",
              onPressed: () {},
            ),
            SizedBox(height: 16.0),
            WActionButton(
              svgPath: AppSvg.icInfo,
              buttonName: "Ilova haqida",
              onPressed: () {},
            ),
            SizedBox(height: 16.0),
            WActionButton(
              svgPath: AppSvg.icLogout,
              buttonName: "Ilovadan chiqish",
              iconColor: AppColors.redColor,
              txtColor: AppColors.redColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
