import 'package:flutter/material.dart';
import 'package:uts_cargo/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:uts_cargo/features/auth/presentation/widgets/w_date_picker_field.dart';
import 'package:uts_cargo/features/auth/presentation/widgets/w_input_text.dart';
import 'package:uts_cargo/features/auth/presentation/widgets/w_loading_button.dart';
import 'package:uts_cargo/features/auth/presentation/widgets/w_serial_number.dart';
import 'package:uts_cargo/features/auth/presentation/widgets/w_tin_number.dart';

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
  final middleName = TextEditingController();
  final tinNumber = TextEditingController();
  final serialNumber = TextEditingController();
  final dateNumber = TextEditingController();

  bool get isFormValid {
    return firstName.text.trim().length >= 3 &&
        lastName.text.trim().length >= 3 &&
        middleName.text.trim().length >= 3 &&
        tinNumber.text.trim().length == 17 &&
        serialNumber.text.trim().length == 10 &&
        dateNumber.text.trim().length == 10;
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
            SizedBox(height: 64.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Ma'lumotlarni kiriting",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            WInputText(
              controller: firstName,
              hintText: 'Ism',
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 8.0),
            WInputText(
              controller: lastName,
              hintText: 'Familiya',
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 8),
            WInputText(
              controller: middleName,
              hintText: 'Otasining ismi',
              onChanged: (_) => _updateState(),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Paspurt ma'lumotlarini kiriting",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: WLoadingButton(
            title: "Ro'yxatdan o'tish",
            isOnPressed: isFormValid,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      OtpVerificationPage(phoneNumber: widget.phoneNumber),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
