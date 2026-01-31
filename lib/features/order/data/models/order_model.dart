import '../../../../core/enums/order_status.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.userId,
    required super.orderName,
    required super.trackCode,
    required super.status,
    required super.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      userId: json['user_id'],
      orderName: json['order_name'],
      trackCode: json['track_code'],
      date: json['date'],
      status: OrderStatus.values[json['status']],
    );
  }
}
