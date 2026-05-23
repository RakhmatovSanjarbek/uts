import 'package:uts_cargo/data/datasource/order_remote_data_source.dart';
import 'package:uts_cargo/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource remote;

  OrderRepositoryImpl(this.remote);

  @override
  Future<OrderListModel> getOrders({
    int page = 1,
    String? search,
    String? status,
  }) async {
    return await remote.getOrders(page: page, search: search, status: status);
  }
}