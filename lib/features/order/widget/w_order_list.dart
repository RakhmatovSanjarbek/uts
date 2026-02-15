import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/order_status_mapper.dart';
import '../../../../data/models/order_model/order_model.dart';

class WOrderList extends StatelessWidget {
  final List<OrderModel> orders;

  const WOrderList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/empty.json',
              width: 200,
              height: 200,
            ),
            const Text(
              'Buyurtmalar topilmadi',
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Trak kodi",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grayColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                order.trackCode,
                style: const TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Right side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: OrderStatusMapper.color(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      OrderStatusMapper.icon(order.status),
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        OrderStatusMapper.color(order.status),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      OrderStatusMapper.text(order.status),
                      style: TextStyle(
                        color: OrderStatusMapper.color(order.status),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Date
              Text(
                _formatDate(order.deliveredAt ?? order.createdAt),
                style: const TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }
}