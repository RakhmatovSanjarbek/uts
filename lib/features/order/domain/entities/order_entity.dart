import '../../../../core/enums/order_status.dart';

class OrderEntity {
  final String userId;
  final String orderName;
  final String trackCode;
  final String date;
  final OrderStatus status;

  const OrderEntity({
    required this.userId,
    required this.orderName,
    required this.trackCode,
    required this.date,
    required this.status,
  });
}
