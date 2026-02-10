import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WCategoryBar extends StatelessWidget {
  final List<String> categories;
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const WCategoryBar({
    super.key,
    required this.categories,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final status = categories[index];
          final bool isSelected = selectedStatus == status;

          return GestureDetector(
            onTap: () => onStatusSelected(status),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.mainColor
                    : AppColors.grayColor200,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
