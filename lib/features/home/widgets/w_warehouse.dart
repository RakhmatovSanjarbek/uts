import 'package:flutter/material.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import '../../../data/models/warehouse/arrived_group_response.dart';
import '../pages/delivery_page.dart';
import '../pages/payment_page.dart';

class WWarehouse extends StatelessWidget {
  final List<ArrivedGroupResponse> model;

  const WWarehouse({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final activeOrders = model.where((item) => item.paymentStatus != "Topshirildi").toList();
    if (activeOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(AppStrings.noOrdersYet, style: TextStyle(color: AppColors.grayColor)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: activeOrders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildWarehouseCard(context, activeOrders[index]),
    );
  }

  Widget _buildWarehouseCard(BuildContext context, ArrivedGroupResponse item) {
    final statusTheme = _getStatusTheme(item.paymentStatus);

    return InkWell(
      onTap: () => _handleNavigation(context, item),
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _buildImage(item.image),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppStrings.resCode} ${item.receiptCode}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                        const SizedBox(height: 4.0),
                        Text("${AppStrings.weight} ${item.totalWeight} kg",
                            style: TextStyle(color: AppColors.grayColor, fontSize: 13.0)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${item.totalPrice} \$",
                          style: const TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 16.0)),
                      const SizedBox(height: 6.0),
                      _buildStatusBadge(statusTheme, item.paymentStatus),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5),
            _buildCargosList(item.cargos),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, ArrivedGroupResponse item) {
    if (item.paymentStatus == "To'lov kutilmoqda" || item.paymentStatus == "To'lov rad etildi") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentUploadPage(group: item)));
    }
    else if (item.paymentStatus == "To'lov tasdiqlandi" && item.deliveryMethod == null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => DeliverySelectionPage(groupId: item.id)));
    }
  }

  Widget _buildCargosList(List<CargoItem> cargos) {
    if (cargos.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: cargos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.screenColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          alignment: Alignment.center,
          child: Text(cargos[index].trackCode,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.blueGrey)),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Image.network(
        "${Constants.baseUrl}/$imageUrl",
        width: 55, height: 55, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 55, height: 55, color: AppColors.screenColor,
          child: Icon(Icons.inventory_2_outlined, color: AppColors.grayColor),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Map<String, dynamic> theme, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: theme['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: TextStyle(color: theme['color'], fontSize: 11.0, fontWeight: FontWeight.w600)),
    );
  }

  Map<String, dynamic> _getStatusTheme(String status) {
    switch (status) {
      case "To'lov kutilmoqda": return {'color': Colors.orange};
      case "Tasdiqlash jarayonida": return {'color': Colors.blue};
      case "To'lov tasdiqlandi": return {'color': Colors.green};
      case "To'lov rad etildi": return {'color': Colors.red};
      case "Topshirildi": return {'color': Colors.teal};
      default: return {'color': Colors.grey};
    }
  }
}