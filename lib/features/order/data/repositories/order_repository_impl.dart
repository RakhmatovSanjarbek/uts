import '../../domain/repositories/order_repository.dart';
import '../../domain/entities/order_entity.dart';
import '../mock/order_mock_data.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<List<OrderEntity>> getOrders() async {
    return mockOrders;
  }
}
