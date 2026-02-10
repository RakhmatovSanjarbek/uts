import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/profile/bloc/profile_bloc.dart';
import 'package:uts_cargo/features/profile/widgets/w_action_button.dart';
import 'package:uts_cargo/features/profile/widgets/w_user_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            context.showSnackBarMessage(state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;
          return RefreshIndicator(
            onRefresh: _refreshProfile,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.0),
                  Text(
                    "Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(left: 16.0),
                  SizedBox(height: 16.0),
                  if (state is ProfileSuccess)
                    WUserInfo(
                      isLoading: isLoading,
                      model: state.model,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: state.model.userId),
                        );
                        context.showSnackBarMessage("Foydalanuvchi ID si nusxalandi");
                      },
                    ),
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
        },
      ),
    );
  }

  Future<void> _refreshProfile() async {
    context.read<ProfileBloc>().add(GetProfileEvent());
    await Future.delayed(const Duration(seconds: 1));
  }
}
