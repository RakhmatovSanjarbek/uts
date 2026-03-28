import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/string/app_string.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_model/user_relative_model.dart';
import '../../auth/widgets/w_date_picker_field.dart';
import '../../auth/widgets/w_phone_number.dart';
import '../../auth/widgets/w_serial_number.dart';
import '../../auth/widgets/w_tin_number.dart';
import '../../auth/widgets/w_loading_button.dart'; // WLoadingButton ishlatamiz
import '../bloc/profile_bloc.dart';

class WAddRelativeBottomSheet extends StatefulWidget {
  const WAddRelativeBottomSheet({super.key});

  @override
  State<WAddRelativeBottomSheet> createState() => _WAddRelativeBottomSheetState();
}

class _WAddRelativeBottomSheetState extends State<WAddRelativeBottomSheet> {
  final nameController = TextEditingController();
  final tinController = TextEditingController();
  final serialController = TextEditingController();
  final dateController = TextEditingController();
  final phoneController = TextEditingController();

  bool get isFormValid {
    return nameController.text.trim().length >= 3 &&
        _cleanValue(tinController.text).length == 14 &&
        _cleanValue(serialController.text).length == 9 &&
        dateController.text.trim().length == 10 &&
        phoneController.text.trim().length>=12;
  }

  String _cleanValue(String value) => value.replaceAll(RegExp(r'\s+'), '');

  void _updateState() => setState(() {});

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateState);
    tinController.addListener(_updateState);
    serialController.addListener(_updateState);
    dateController.addListener(_updateState);
    phoneController.addListener(_updateState);
  }

  @override
  void dispose() {
    nameController.dispose();
    tinController.dispose();
    serialController.dispose();
    dateController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is PassportActionSuccess) {
          Navigator.pop(context);
          context.showSnackBarMessage(state.message);
        } else if (state is ProfileFailure) {
          context.showSnackBarMessage(state.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading;

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.grayColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.addNewPassport,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // F.I.SH field
                TextField(
                  controller: nameController,
                  onChanged: (_) => _updateState(),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: AppStrings.fullNameLabel,
                    hintText: AppStrings.enterFullName,
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.mainColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ).paddingSymmetric(horizontal: 16.0),
                const SizedBox(height: 12),

                WTinNumber(
                  controller: tinController,
                  onChanged: (_) => _updateState(),
                ).paddingSymmetric(horizontal: 0),

                const SizedBox(height: 12),
                WSerialNumber(
                  controller: serialController,
                  onChanged: (_) => _updateState(),
                ),
                const SizedBox(height: 12),
                WDatePickerField(
                  controller: dateController,
                  onChanged: (_) => _updateState(),
                ),
                const SizedBox(height: 12),
                WPhoneNumber(
                  phoneNumber: phoneController,
                  onChanged: (_) => _updateState(),
                ),
                const SizedBox(height: 24),
                WLoadingButton(
                  title: AppStrings.save,
                  isLoading: isLoading,
                  isOnPressed: isFormValid,
                  onPressed: _addPassport,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addPassport() {
    final model = UserRelativeModel(
      fullName: nameController.text.trim(),
      jshshir: _cleanValue(tinController.text),
      passportSeries: _cleanValue(serialController.text).toUpperCase(),
      birthDate: _formatBirthDate(dateController.text),
      phone: phoneController.text.trim(),
    );

    context.read<ProfileBloc>().add(AddPassportEvent(model));
  }

  String _formatBirthDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return value;
    return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }
}