import 'package:flutter/material.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/home/pages/warehouse_page.dart';

import '../../../data/models/warehouse/arrived_group_response.dart';

class WWarehouse extends StatelessWidget {
  final String fullName;
  final String userID;
  final ArrivedGroupResponse model;

  const WWarehouse({
    super.key,
    required this.model,
    required this.fullName,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    if (model.paymentStatus == "Topshirildi") {
      return const SizedBox.shrink();
    }

    final statusTheme = _getStatusTheme(model.paymentStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () => _handleNavigation(context, model),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
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
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${model.totalPrice} \$",
                          style: const TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        _buildStatusBadge(statusTheme, model.paymentStatus),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 0.5),
              _buildCargosList(model.cargos),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, ArrivedGroupResponse item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WarehousePage(model: model, fullName: fullName, userID: userID,)),
    );
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
          child: Text(
            cargos[index].trackCode,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: Image.network(
        "${Constants.baseUrl}/$imageUrl",
        width: 55,
        height: 55,
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
