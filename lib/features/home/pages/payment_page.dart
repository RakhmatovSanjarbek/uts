import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import '../../../data/models/warehouse/arrived_group_response.dart';
import '../bloc/warehouse_bloc.dart';

class PaymentUploadPage extends StatefulWidget {
  final ArrivedGroupResponse group;
  const PaymentUploadPage({super.key, required this.group});

  @override
  State<PaymentUploadPage> createState() => _PaymentUploadPageState();
}

class _PaymentUploadPageState extends State<PaymentUploadPage> {
  File? _imageFile;
  final String _cardNumber = "8600 5000 1122 3344";

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _copyCard() {
    Clipboard.setData(ClipboardData(text: _cardNumber.replaceAll(' ', '')));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Karta raqami nusxalandi"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WarehouseBloc, WarehouseState>(
      listener: (context, state) {
        if (state is WarehouseLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Chek muvaffaqiyatli yuborildi!")),
          );
          Navigator.pop(context);
        } else if (state is WarehouseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is WarehouseLoading;

        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.payment)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildCardWidget(),
                const SizedBox(height: 30),
                Text(
                  "${AppStrings.totalSum} ${widget.group.totalPrice} \$",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _buildImagePicker(isLoading),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (_imageFile == null || isLoading)
                  ? null
                  : () {
                context.read<WarehouseBloc>().add(
                  UploadCheckEvent(widget.group.id, [_imageFile!.path]),
                );
              },
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2),
              )
                  : Text(
                AppStrings.confirm,
                style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF141E30), Color(0xFF243B55)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.paymentCard, style: TextStyle(color: AppColors.whiteColor)),
              IconButton(
                onPressed: _copyCard,
                icon: const Icon(Icons.copy, color: AppColors.whiteColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_cardNumber,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              )),
          const SizedBox(height: 15),
          Text("UTS CARGO LOGISTICS", style: TextStyle(color: AppColors.whiteColor, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildImagePicker(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.grayColor200,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.mainColor.withOpacity(0.3), width: 2),
        ),
        child: _imageFile != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.file(_imageFile!, fit: BoxFit.cover),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 50, color: AppColors.grayColor),
            Text(AppStrings.uploadReceipt, style: TextStyle(color: AppColors.grayColor)),
          ],
        ),
      ),
    );
  }
}