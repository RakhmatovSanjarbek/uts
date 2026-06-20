import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/data/models/auth_model/sign_up_model.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import 'package:uts_cargo/features/auth/widgets/w_date_picker_field.dart';
import 'package:uts_cargo/features/auth/widgets/w_input_text.dart';
import 'package:uts_cargo/features/auth/widgets/w_loading_button.dart';
import 'package:uts_cargo/features/auth/widgets/w_serial_number.dart';
import 'package:uts_cargo/features/auth/widgets/w_tin_number.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/w_image_picker.dart';

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

  File? passportFront;
  File? passportBack;
  final ImagePicker _picker = ImagePicker();

  bool get isFormValid =>
      firstName.text.trim().length >= 3 &&
          lastName.text.trim().length >= 3 &&
          tinNumber.text.trim().length == 17 &&
          serialNumber.text.trim().length == 10 &&
          dateNumber.text.trim().length == 10 &&
          address.text.trim().length >= 5 &&
          passportFront != null &&
          passportBack != null;

  void _updateState() => setState(() {});

  Future<void> _pickImage(bool isFront) async {
    final source = await _showSourceDialog();
    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (picked != null) {
      setState(() {
        if (isFront) {
          passportFront = File(picked.path);
        } else {
          passportBack = File(picked.path);
        }
      });
    }
  }

  Future<ImageSource?> _showSourceDialog() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galereya'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
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
            const SizedBox(height: 36.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
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
                const SizedBox(width: 56.0),
              ],
            ),
            const SizedBox(height: 8.0),
            WInputText(
              controller: firstName,
              hintText: AppStrings.firstName,
              onChanged: (_) => _updateState(),
            ),
            const SizedBox(height: 8.0),
            WInputText(
              controller: lastName,
              hintText: AppStrings.lastName,
              onChanged: (_) => _updateState(),
            ),
            const SizedBox(height: 8),
            WInputText(
              controller: address,
              hintText: AppStrings.fullAddress,
              onChanged: (_) => _updateState(),
            ),
            const SizedBox(height: 8.0),
            Text(
              AppStrings.enterPassportInfo,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ).paddingSymmetric(horizontal: 16.0),
            const SizedBox(height: 8),
            WTinNumber(controller: tinNumber, onChanged: (_) => _updateState()),
            const SizedBox(height: 8),
            WSerialNumber(
              controller: serialNumber,
              onChanged: (_) => _updateState(),
            ),
            const SizedBox(height: 8),
            WDatePickerField(
              controller: dateNumber,
              onChanged: (_) => _updateState(),
            ),
            const SizedBox(height: 20.0),
            Text(
              AppStrings.uploadPassport,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ).paddingSymmetric(horizontal: 16.0),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  child: WImagePicker(
                    title: AppStrings.frontSide,
                    image: passportFront,
                    onTap: () => _pickImage(true),
                  ),
                ),
                Expanded(
                  child: WImagePicker(
                    title: AppStrings.backSide,
                    image: passportBack,
                    onTap: () => _pickImage(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
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
              return WLoadingButton(
                title: AppStrings.registration,
                isOnPressed: isFormValid,
                isLoading: state is AuthLoading,
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
                        birthDate: _formatBirthDate(dateNumber.text),
                        passportFront: passportFront,
                        passportBack: passportBack,
                      ),
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

  String _formatJshshir(String value) => value.replaceAll(RegExp(r'\s+'), '');

  String _formatPassport(String value) =>
      value.replaceAll(RegExp(r'\s+'), '').toUpperCase();

  String _formatBirthDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return value;
    return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }
}