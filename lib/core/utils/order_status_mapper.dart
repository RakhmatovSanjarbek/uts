import 'package:flutter/material.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';

class OrderStatusMapper {
  static Color color(String status) {
    switch (status) {
      case "Omborda":
        return Colors.deepPurple;
      case "Punktda":
        return Colors.orange;
      case "Yo'lda":
        return Colors.blue;
      case "Topshirildi":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static String icon(String status) {
    switch (status) {
      case "Omborda":
        return AppSvg.icWareHouse;
      case "Punktda":
        return AppSvg.icPoint;
      case "Yo'lda":
        return AppSvg.icCar;
      case "Topshirildi":
        return AppSvg.icDelivered;
      default:
        return AppSvg.icCar;
    }
  }

  static String text(status) {
    return status.toString();
  }
}
