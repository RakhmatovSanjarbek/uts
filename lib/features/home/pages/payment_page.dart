import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../data/models/warehouse/arrived_group_response.dart';
import '../bloc/info_bloc/info_bloc.dart';
import '../bloc/warehouse_bloc/warehouse_bloc.dart';

class PaymentUploadPage extends StatefulWidget {
  final ArrivedGroupResponse group;
  const PaymentUploadPage({super.key, required this.group});

  @override
  State<PaymentUploadPage> createState() => _PaymentUploadPageState();
}

class _PaymentUploadPageState extends State<PaymentUploadPage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _copyCard(BuildContext context, String number) {
    Clipboard.setData(ClipboardData(text: number.replaceAll(' ', '')));
    context.showSnackBarMessage(AppStrings.cardCopied);
  }

  String _formatSum(String dollarPrice, double rate) {
    if (rate <= 0) return '';
    final dollars = double.tryParse(dollarPrice) ?? 0;
    final sum = (dollars * rate).toStringAsFixed(0);
    return sum.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WarehouseBloc, WarehouseState>(
      listener: (context, state) {
        if (state is WarehouseLoaded) {
          context.showSnackBarMessage(AppStrings.receiptSent);
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state is WarehouseError) {
          context.showSnackBarMessage(state.message);
        }
      },
      builder: (context, warehouseState) {
        final bool isLoading = warehouseState is WarehouseLoading;

        return BlocBuilder<InfoBloc, InfoState>(
          builder: (context, infoState) {
            final cardNumber = infoState is InfoSuccess
                ? infoState.model.paymentCard.number
                : '';
            final cardHolder = infoState is InfoSuccess
                ? infoState.model.paymentCard.holder
                : '';
            final dollarRate = infoState is InfoSuccess
                ? infoState.model.dollarRate
                : 0.0;

            return Scaffold(
              backgroundColor: AppColors.screenColor,
              appBar: AppBar(title: Text(AppStrings.payment)),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCardWidget(context, cardNumber, cardHolder),
                    const SizedBox(height: 16),
                    _buildPriceWidget(dollarRate),
                    const SizedBox(height: 16),
                    _buildImagePicker(isLoading),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    disabledBackgroundColor: AppColors.mainColor.withOpacity(0.4),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: (_imageFile == null || isLoading)
                      ? null
                      : () {
                    context.read<WarehouseBloc>().add(
                      UploadCheckEvent(widget.group.id, [_imageFile!.path]),
                    );
                  },
                  icon: isLoading
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    AppStrings.confirm,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardWidget(BuildContext context, String number, String holder) {
    final displayNumber = number.isNotEmpty ? number : '---- ---- ---- ----';
    final displayHolder = holder.isNotEmpty ? holder : '---';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6E56), Color(0xFF1D3B5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'To\'lov kartasi',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            displayNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 3,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KARTA EGASI',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayHolder,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _copyCard(context, displayNumber),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white30, width: 0.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.copy_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Nusxalash',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceWidget(double dollarRate) {
    final sumText = _formatSum(widget.group.totalPrice, dollarRate);
    final dollars = double.tryParse(widget.group.totalPrice) ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jami to\'lov miqdori',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                dollars.toStringAsFixed(dollars.truncateToDouble() == dollars ? 0 : 2),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '\$',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (sumText.isNotEmpty) ...[
            const Divider(height: 24, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'So\'mda',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: sumText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const TextSpan(
                            text: ' so\'m',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Kurs',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '1 \$ = ${dollarRate.toStringAsFixed(0)} so\'m',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePicker(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _imageFile != null
                ? AppColors.mainColor.withOpacity(0.5)
                : Colors.grey.shade200,
            width: _imageFile != null ? 1.5 : 0.5,
          ),
        ),
        child: _imageFile != null
            ? Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => setState(() => _imageFile = null),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 32,
                color: AppColors.mainColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Chek rasmini yuklang',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Galereya yoki kameradan',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}