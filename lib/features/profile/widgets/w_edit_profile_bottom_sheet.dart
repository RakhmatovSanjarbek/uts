import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../data/models/user_model/user_model.dart';
import '../../auth/widgets/w_date_picker_field.dart';
import '../../auth/widgets/w_serial_number.dart';
import '../../auth/widgets/w_tin_number.dart';
import '../bloc/profile_bloc.dart';

class WEditProfileBottomSheet extends StatefulWidget {
  final UserModel user;
  final VoidCallback? onUpdated;

  const WEditProfileBottomSheet({
    super.key,
    required this.user,
    this.onUpdated,
  });

  @override
  State<WEditProfileBottomSheet> createState() =>
      _WEditProfileBottomSheetState();
}

class _WEditProfileBottomSheetState extends State<WEditProfileBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController tinController;
  late TextEditingController serialController;
  late TextEditingController dateController;
  late TextEditingController addressController;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    tinController = TextEditingController(text: widget.user.jshshir);
    serialController = TextEditingController(text: widget.user.passportSeries);
    dateController = TextEditingController(text: widget.user.birthDate);
    addressController = TextEditingController(text: widget.user.address);

    _validate();
    nameController.addListener(_validate);
    lastNameController.addListener(_validate);
    tinController.addListener(_validate);
    serialController.addListener(_validate);
    dateController.addListener(_validate);
    addressController.addListener(_validate);
  }

  void _validate() {
    setState(() {
      final cleanTin = tinController.text.replaceAll(RegExp(r'\s+'), '');
      final cleanSerial = serialController.text.replaceAll(RegExp(r'\s+'), '');

      _isFormValid = nameController.text.trim().isNotEmpty &&
          lastNameController.text.trim().isNotEmpty &&
          cleanTin.length == 14 &&
          cleanSerial.length == 9 &&
          dateController.text.trim().isNotEmpty &&
          addressController.text.trim().length >= 5;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    tinController.dispose();
    serialController.dispose();
    dateController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grayColor200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              AppStrings.editProfile,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 25),

            _buildCustomField(
              controller: nameController,
              label: AppStrings.firstName,
            ).paddingSymmetric(horizontal: 16.0),
            const SizedBox(height: 16),

            _buildCustomField(
              controller: lastNameController,
              label: AppStrings.lastName,
            ).paddingSymmetric(horizontal: 16.0),
            const SizedBox(height: 16),

            WTinNumber(
              controller: tinController,
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 16),

            WSerialNumber(
              controller: serialController,
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 16),

            WDatePickerField(
              controller: dateController,
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 16),

            _buildCustomField(
              controller: addressController,
              label: AppStrings.fullAddress,
            ).paddingSymmetric(horizontal: 16.0),

            const SizedBox(height: 32),

            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileSuccess) {
                  if (widget.onUpdated != null) {
                    widget.onUpdated!();
                  }
                  Navigator.pop(context);
                  context.showSnackBarMessage(AppStrings.profileUpdated);
                } else if (state is ProfileFailure) {
                  context.showSnackBarMessage(state.error);
                }
              },
              builder: (context, state) {
                final isLoading = state is ProfileLoading;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_isFormValid && !isLoading)
                          ? _updateProfile
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ?  SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.whiteColor,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        AppStrings.save,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
    final updatedUser = UserModel(
      id: widget.user.id,
      userId: widget.user.userId,
      phone: widget.user.phone,
      firstName: nameController.text.trim(),
      lastName: lastNameController.text.trim(),
      jshshir: tinController.text.trim(),
      passportSeries: serialController.text.trim().toUpperCase(),
      birthDate: dateController.text.trim(),
      address: addressController.text.trim(),
    );
    context.read<ProfileBloc>().add(UpdateProfileEvent(updatedUser));
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.w500),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.grayColor200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grayColor200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.mainColor, width: 1.5),
        ),
      ),
    );
  }
}