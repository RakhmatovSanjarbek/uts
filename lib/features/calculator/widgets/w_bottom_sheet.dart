import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/data/models/calculator_model/calculator_request.dart';
import 'package:uts_cargo/features/auth/widgets/w_loading_button.dart';
import '../bloc/calculator_bloc.dart';

class WBottomSheet extends StatefulWidget {
  const WBottomSheet({super.key});

  @override
  State<WBottomSheet> createState() => _WBottomSheetState();
}

class _WBottomSheetState extends State<WBottomSheet> {
  final weightController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final commentController = TextEditingController();
  File? _selectedImage;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    weightController.addListener(_validateForm);
    lengthController.addListener(_validateForm);
    widthController.addListener(_validateForm);
    heightController.addListener(_validateForm);
  }

  @override
  void dispose() {
    weightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final valid = weightController.text.isNotEmpty &&
        lengthController.text.isNotEmpty &&
        widthController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        _selectedImage != null;
    if (valid != _isFormValid) setState(() => _isFormValid = valid);
  }

  Future<void> _pickImage() async {
    final source = await _showSourceDialog();
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1920,
      maxHeight: 1920,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
      _validateForm();
    }
  }

  Future<ImageSource?> _showSourceDialog() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galereya'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalculatorBloc, CalculatorState>(
      listener: (context, state) {
        if (state is CalculatorCreateSuccess) {
          Navigator.pop(context);
        } else if (state is CalculatorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12.0),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grayColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        height: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color: AppColors.mainColor, width: 2.0),
                          image: _selectedImage != null
                              ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _selectedImage == null
                            ? SvgPicture.asset(
                          AppSvg.icAddImage,
                          colorFilter: const ColorFilter.mode(
                            AppColors.mainColor,
                            BlendMode.srcIn,
                          ),
                        ).paddingAll(24.0)
                            : const SizedBox.shrink(),
                      ),
                    ),
                    _buildTextField(
                      controller: weightController,
                      label: '${AppStrings.weight} (${AppStrings.kg})',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: lengthController,
                            label: AppStrings.length,
                            keyboardType: TextInputType.number,
                            padding: const EdgeInsets.only(right: 4.0),
                          ),
                        ),
                        Expanded(
                          child: _buildTextField(
                            controller: widthController,
                            label: AppStrings.width,
                            keyboardType: TextInputType.number,
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          ),
                        ),
                        Expanded(
                          child: _buildTextField(
                            controller: heightController,
                            label: AppStrings.height,
                            keyboardType: TextInputType.number,
                            padding: const EdgeInsets.only(left: 4.0),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16.0),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      controller: commentController,
                      label: AppStrings.commentOptional,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (context, state) {
                final isLoading = state is CalculatorUploading;
                return WLoadingButton(
                  title: AppStrings.submit,
                  isLoading: isLoading,
                  isOnPressed: _isFormValid,
                  onPressed: () {
                    if (!_isFormValid || isLoading) return;
                    context.read<CalculatorBloc>().add(
                      CreateCalculationEvent(
                        CalculatorRequest(
                          images: _selectedImage!,
                          weight: weightController.text,
                          length: lengthController.text,
                          width: widthController.text,
                          height: heightController.text,
                          comment: commentController.text,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    EdgeInsetsGeometry? padding,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.grayColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: AppColors.mainColor),
          ),
        ),
      ),
    );
  }
}