import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/data/models/auth_model/sign_up_model.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/widgets/w_date_picker_field.dart';
import 'package:uts_cargo/features/auth/widgets/w_input_text.dart';
import 'package:uts_cargo/features/auth/widgets/w_loading_button.dart';
import 'package:uts_cargo/features/auth/widgets/w_serial_number.dart';
import 'package:uts_cargo/features/auth/widgets/w_tin_number.dart';

import '../../../../core/theme/app_colors.dart';

class EnterFullInfoPage extends StatefulWidget {
  final String phoneNumber;

  const EnterFullInfoPage({super.key, required this.phoneNumber});

  @override
  State<EnterFullInfoPage> createState() => _EnterFullInfoPageState();
}

class _EnterFullInfoPageState extends State<EnterFullInfoPage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final tinNumber = TextEditingController();
  final serialNumber = TextEditingController();
  final dateNumber = TextEditingController();
  final address = TextEditingController();

  bool get isFormValid {
    return firstName.text
        .trim()
        .length >= 3 &&
        lastName.text
            .trim()
            .length >= 3 &&
        tinNumber.text
            .trim()
            .length == 17 &&
        serialNumber.text
            .trim()
            .length == 10 &&
        dateNumber.text
            .trim()
            .length == 10 &&
        address.text
            .trim()
            .length >= 15;
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 36.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppStrings.back,
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).paddingOnly(left: 8.0),
                Text(
                  AppStrings.enterInfo,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 56.0),
              ],
            ),
            SizedBox(height: 8.0),
            WInputText(
              controller: firstName,
              hintText: AppStrings.firstName,
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 8.0),
            WInputText(
              controller: lastName,
              hintText: AppStrings.lastName,
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 8),
            WInputText(
              controller: address,
              hintText: AppStrings.fullAddress,
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 8.0),
            Text(
              AppStrings.enterPassportInfo,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).paddingSymmetric(horizontal: 16.0),
            SizedBox(height: 8),
            WTinNumber(controller: tinNumber, onChanged: (_) => _updateState()),
            SizedBox(height: 8),
            WSerialNumber(
              controller: serialNumber,
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 8),
            WDatePickerField(
              controller: dateNumber,
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom + 16.0,
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                context.showSnackBarMessage(state.response.message);
                Navigator.pushNamed(
                  context,
                  "/verify",
                  arguments: widget.phoneNumber,
                );
              } else if (state is AuthFailure) {
                context.showSnackBarMessage(state.error);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return WLoadingButton(
                title: AppStrings.registration,
                isOnPressed: isFormValid,
                isLoading: isLoading,
                onPressed: () {
                  context.read<AuthBloc>().add(
                    SignUpEvent(
                      SignUpModel(
                          address: address.text.trim(),
                          phone: widget.phoneNumber,
                          firstName: firstName.text.trim(),
                          lastName: lastName.text.trim(),
                          jshshir: _formatJshshir(tinNumber.text),
                          passportSeries: _formatPassport(serialNumber.text),
                          birthDate: _formatBirthDate(dateNumber.text)
                      )
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatJshshir(String value) {
    return value.replaceAll(RegExp(r'\s+'), '');
  }

  String _formatPassport(String value) {
    return value.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }

  String _formatBirthDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return value;

    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];

    return '$year-$month-$day';
  }
}
