import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/enums/order_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/order_status_mapper.dart';
import '../../data/mock/order_mock_data.dart';
import '../../domain/entities/order_entity.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderStatus selectedStatus = OrderStatus.all;

  List<OrderEntity> get filteredOrders {
    if (selectedStatus == OrderStatus.all) {
      return mockOrders;
    }
    return mockOrders.where((order) => order.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 48.0),
          Container(
            margin: EdgeInsets.only(left: 16.0),
            child: Text(
              "Buyurtmalar",
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildCategoryBar(),
          const SizedBox(height: 16),
          _buildOrderList(),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: OrderStatus.values.length,
        itemBuilder: (context, index) {
          final status = OrderStatus.values[index];
          final isSelected = selectedStatus == status;

          return GestureDetector(
            onTap: () {
              setState(() => selectedStatus = status);
            },
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
                OrderStatusMapper.text(status),
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

  Widget _buildOrderList() {
    if (filteredOrders.isEmpty) {
      return const Expanded(
        child: Center(child: Text("Bu statusda yuklar yo‘q")),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredOrders.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final order = filteredOrders[index];

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
                      order.orderName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Track code: ${order.trackCode}",
                      style: TextStyle(color: AppColors.grayColor),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: OrderStatusMapper.color(
                          order.status,
                        ).withOpacity(0.2),
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
                          SizedBox(width: 8.0),
                          Text(
                            OrderStatusMapper.text(order.status),
                            style: TextStyle(
                              color: OrderStatusMapper.color(order.status),
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Sana: ${order.date}",
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
