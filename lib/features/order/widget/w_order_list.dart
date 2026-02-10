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
      return Expanded(
        child: Center(
          child: Lottie.asset(
            'assets/lottie/empty.json',
            animate: true, // Avtomatik boshlash
            repeat: true, // Takrorlash
            reverse: false, // Teskari o'ynatish
            frameRate: FrameRate(60),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: orders.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderItem(order);
        },
      ),
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Trak kodi",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.grayColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                order.trackCode,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: OrderStatusMapper.color(order.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      OrderStatusMapper.icon(order.status),
                      width: 24.0,
                      height: 24.0,
                      colorFilter: ColorFilter.mode(
                        OrderStatusMapper.color(order.status),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      OrderStatusMapper.text(order.status),
                      style: TextStyle(
                        color: OrderStatusMapper.color(order.status),
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                order.deliveredAt != null
                    ? _formatDateTime(order.deliveredAt!)
                    : _formatDateTime(order.createdAt),
                style: TextStyle(color: AppColors.grayColor, fontSize: 14.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }
}
