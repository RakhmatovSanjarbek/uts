import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/pages/payment_page.dart';

import '../../../core/constants/constants.dart';
import '../../../data/models/warehouse/arrived_group_response.dart';
import '../../profile/widgets/w_qrcode_bottom_sheet.dart';
import 'delivery_page.dart';

class WarehousePage extends StatelessWidget {
  final String phoneNumber;
  final String fullName;
  final String userID;
  final ArrivedGroupResponse model;

  const WarehousePage({
    super.key,
    required this.model,
    required this.fullName,
    required this.userID,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final statusTheme = _getStatusTheme(model.paymentStatus);
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenColor,
        actions: [
          IconButton(
            onPressed: () {
              _showQRBottomSheet(context, model.receiptCode);
            },
            icon: SvgPicture.asset(
              AppSvg.icQrCod,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          AppStrings.order,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                _buildImage(context, model.image),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppStrings.resCode} ${model.receiptCode}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "${AppStrings.weight} ${model.totalWeight} ${AppStrings.kg}",
                        style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 13.0,
                        ),
                      ),
                      Text(
                        "${model.totalPrice} \$",
                        style: const TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 13.0,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      _buildStatusBadge(statusTheme, model.paymentStatus),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(model.cargos.length, (index) {
                return Chip(
                  label: Text(
                    model.cargos[index].trackCode,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  backgroundColor: AppColors.mainColor.withOpacity(0.1),
                  avatar: SvgPicture.asset(AppSvg.icBox),
                );
              }),
            ),
            const SizedBox(height: 20.0),
            Visibility(
              visible: model.paymentStatus == "To'lov rad etildi",
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: AppColors.redColor),
                  color: AppColors.redColor30,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  model.adminNote.isNotEmpty
                      ? "${AppStrings.rejectionReason}: ${model.adminNote}"
                      : AppStrings.noRejectionReason,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 16.0),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 32.0),
        child:
            model.paymentStatus == "Topshirildi" ||
                model.paymentStatus == "Tasdiqlash jarayonida"
            ? const SizedBox.shrink()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (model.paymentStatus == "To'lov kutilmoqda" ||
                      model.paymentStatus == "To'lov rad etildi") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentUploadPage(group: model),
                      ),
                    );
                  } else if (model.paymentStatus == "To'lov tasdiqlandi") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliverySelectionPage(
                          groupId: model.id,
                          resCode: model.receiptCode,
                          phoneNumber: phoneNumber,
                          fullName: fullName,
                          userID: userID,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  model.paymentStatus == "To'lov kutilmoqda"
                      ? AppStrings.makePayment
                      : model.paymentStatus == "To'lov tasdiqlandi" &&
                            model.deliveryMethod == null
                      ? AppStrings.selectPickup
                      : model.paymentStatus == "To'lov rad etildi"
                      ? AppStrings.rePay
                      : model.deliveryMethod != null
                      ? AppStrings.changePickupOrder
                      : "",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

// Metod:
  Widget _buildImage(BuildContext context, String? imageUrl) {
    final url = "${Constants.baseUrl}/$imageUrl";
    return GestureDetector(
      onTap: () => _showFullScreenImage(context, url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          url,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 55,
            height: 55,
            color: AppColors.screenColor,
            child: Icon(Icons.inventory_2_outlined, color: AppColors.grayColor),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImagePage(imageUrl: url),
      ),
    );
  }

  Widget _buildStatusBadge(Map<String, dynamic> theme, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: theme['color'],
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showQRBottomSheet(BuildContext context, String qrData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WQRCodeBottomSheet(qrData: qrData, title: AppStrings.yourCargoNumber,),
    );
  }

  Map<String, dynamic> _getStatusTheme(String status) {
    switch (status) {
      case "To'lov kutilmoqda":
        return {'color': Colors.orange};
      case "Tasdiqlash jarayonida":
        return {'color': Colors.blue};
      case "To'lov tasdiqlandi":
        return {'color': Colors.green};
      case "To'lov rad etildi":
        return {'color': Colors.red};
      case "Topshirildi":
        return {'color': Colors.teal};
      default:
        return {'color': Colors.grey};
    }
  }
}

class _FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}
