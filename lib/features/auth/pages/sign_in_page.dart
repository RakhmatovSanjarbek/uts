import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/widgets/w_loading_button.dart';
import 'package:uts_cargo/features/auth/widgets/w_phone_number.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final phoneNumber = TextEditingController();

  bool isOnPressed = false;
  bool isChecked = false;

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
                      Text(
                        "Kirish",
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ).paddingSymmetric(horizontal: 16.0),
                      Text(
                        "Telefon raqamingizni kiriting",
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
                      setState(() {
                        isOnPressed = value.length == 12;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  WLoadingButton(
                    title: "Kirish",
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        SignInEvent(_phoneNumber(phoneNumber.text))
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
                                "Ilovaga kirishdan avval foydalanish shartlari bilan tanishib chiqing",
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
                          onPressed: () {},
                          child: Text(
                            "Foydalanish shartlari",
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

  String _phoneNumber(String phone) {
    return "+998${phone.replaceAll(RegExp(r'[^0-9]'), '')}";
  }
}
