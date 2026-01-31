import 'package:flutter/material.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';

import '../enums/order_status.dart';

class OrderStatusMapper {
  static String text(OrderStatus status) {
    switch (status) {
      case OrderStatus.warehouse:
        return "Omborda";
      case OrderStatus.pickupPoint:
        return "Punktda";
      case OrderStatus.onTheWay:
        return "Yo‘lda";
      case OrderStatus.delivered:
        return "Topshirildi";
      case OrderStatus.all:
        return "Barchasi";
    }
  }

  static Color color(OrderStatus status) {
    switch (status) {
      case OrderStatus.warehouse:
        return Colors.deepPurple;
      case OrderStatus.pickupPoint:
        return Colors.orange;
      case OrderStatus.onTheWay:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.all:
        return Colors.grey;
    }
  }

  static String icon(OrderStatus status) {
    switch (status) {
      case OrderStatus.all:
        return AppSvg.icCar;
      case OrderStatus.pickupPoint:
        return AppSvg.icPoint;
      case OrderStatus.onTheWay:
        return AppSvg.icCar;
      case OrderStatus.delivered:
        return AppSvg.icDelivered;
      case OrderStatus.warehouse:
        return AppSvg.icWareHouse;
    }
  }
}
