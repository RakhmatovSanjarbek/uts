import 'package:uts_cargo/data/datasource/order_remote_data_source.dart';

abstract class OrderRepository {
  Future<OrderListModel> getOrders({
    int page = 1,
    String? search,
    String? status,
  });
}