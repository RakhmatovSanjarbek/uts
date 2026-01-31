import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/presentation/pages/enter_full_info_page.dart';
import 'package:uts_cargo/features/auth/presentation/widgets/w_loading_button.dart';
import 'package:uts_cargo/features/auth/presentation/widgets/w_phone_number.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 64.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kirish",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Ilovaga kirish uchun telefon raqamingizni kiriting",
                      style: TextStyle(
                        color: AppColors.blackColor50,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
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
                  final phone =
                      "998${phoneNumber.text.replaceAll(RegExp(r'[^0-9]'), '')}";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EnterFullInfoPage(phoneNumber: phone),
                    ),
                  );
                },
                isOnPressed: isOnPressed,
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
      ),
    );
  }
}
