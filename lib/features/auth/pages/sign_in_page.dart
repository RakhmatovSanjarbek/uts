import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/pages/policy_web_view.dart';
import 'package:uts_cargo/features/auth/widgets/w_loading_button.dart';
import 'package:uts_cargo/features/auth/widgets/w_phone_number.dart';

import '../../profile/widgets/w_language_bottom_sheet.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final phoneNumber = TextEditingController();

  bool isOnPressed = false;
  bool isChecked = false;

  void _validateForm() {
    setState(() {
      final cleanPhone = phoneNumber.text.replaceAll(RegExp(r'[^0-9]'), '');
      isOnPressed = cleanPhone.length == 9 && isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.showSnackBarMessage(state.response.message);
            Navigator.pushNamed(
              context,
              "/verify",
              arguments: _phoneNumber(phoneNumber.text),
            );
          } else if (state is AuthNeedRegister) {
            Navigator.pushNamed(
              context,
              "/register",
              arguments: _phoneNumber(phoneNumber.text),
            );
          } else if (state is AuthFailure) {
            context.showSnackBarMessage(state.error);
          }
        },
        builder: (BuildContext context, AuthState state) {
          final isLoading = state is AuthLoading;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 64.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _showLanguageBottomSheet(context),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppStrings.language,
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              CircleAvatar(
                                radius: 16.0,
                                backgroundImage: _getLangImage(context),
                              ),
                            ],
                          ),
                        ).paddingOnly(right: 16.0),
                      ),
                      Text(
                        AppStrings.login,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ).paddingSymmetric(horizontal: 16.0),
                      Text(
                        AppStrings.enterPhone,
                        style: TextStyle(
                          color: AppColors.blackColor50,
                          fontSize: 16.0,
                        ),
                      ).paddingSymmetric(horizontal: 16.0),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  WPhoneNumber(
                    phoneNumber: phoneNumber,
                    onChanged: (value) {
                      _validateForm();
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  WLoadingButton(
                    title: AppStrings.login,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        SignInEvent(_phoneNumber(phoneNumber.text)),
                      );
                    },
                    isOnPressed: isOnPressed,
                    isLoading: isLoading,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() => isChecked = value!);
                                _validateForm();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              side: BorderSide(
                                color: AppColors.grayColor,
                                width: 1.5,
                              ),
                              activeColor: AppColors.mainColor,
                            ),
                            Expanded(
                              child: Text(
                                AppStrings.termsAgreement,
                                style: TextStyle(
                                  color: AppColors.blackColor50,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            openPolicy(context, AppStrings.usageTerms, "https://utsgroup.uz/terms");
                          },
                          child: Text(
                            AppStrings.usageTerms,
                            style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void openPolicy(BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => PolicyWebView(title: title, url: url),
      ),
    );
  }

  AssetImage _getLangImage(BuildContext context) {
    final locale = context.locale.toString();
    if (locale.contains('uz')) return AssetImage("assets/images/uz_flag.png");
    if (locale.contains('ru')) return AssetImage("assets/images/ru_flag.png");
    return AssetImage("assets/images/uz_flag.png");
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const WLanguageBottomSheet(),
    );
  }

  String _phoneNumber(String phone) {
    return "+998${phone.replaceAll(RegExp(r'[^0-9]'), '')}";
  }
}
