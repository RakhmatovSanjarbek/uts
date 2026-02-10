import 'package:uts_cargo/data/models/order_model/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrder();
}
