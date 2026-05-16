import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uts_cargo/core/extensions/padding_extensions.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/pages/payment_page.dart';

import '../../../core/constants/constants.dart';
import '../../../data/models/warehouse/arrived_group_response.dart';
import 'delivery_page.dart';

class WarehousePage extends StatelessWidget {
  final String fullName;
  final String userID;
  final ArrivedGroupResponse model;

  const WarehousePage({super.key, required this.model, required this.fullName, required this.userID});

  @override
  Widget build(BuildContext context) {
    final statusTheme = _getStatusTheme(model.paymentStatus);
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenColor,
        centerTitle: true,
        title: Text(
          AppStrings.order,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Existing row widget
            Row(
              children: [
                _buildImage(model.image),
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
                        "${AppStrings.weight} ${model.totalWeight} kg",
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
                      ? "Rad etilish sababi: ${model.adminNote}"
                      : "Rad etilish sababi ko'rsatilmagan",
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
                  } else if (model.paymentStatus == "To'lov tasdiqlandi" &&
                      model.deliveryMethod == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DeliverySelectionPage(groupId: model.id, fullName: fullName, userID: userID,),
                      ),
                    );
                  }else if(model.deliveryMethod!=null){
                    context.showSnackBarMessage("Siz tovarni qabul qilish usulini tanlab bo'lgansiz");
                  }
                },
                child: Text(
                  model.paymentStatus == "To'lov kutilmoqda"
                      ? "To'lov qiling"
                      : model.paymentStatus == "To'lov tasdiqlandi"
                      ? "Olib ketishni tanlang"
                      : model.paymentStatus == "To'lov rad etildi"
                      ? "Qayta to'lov qiling"
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

  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.network(
        "${Constants.baseUrl}/$imageUrl",
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
