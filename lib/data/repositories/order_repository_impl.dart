import 'package:uts_cargo/data/datasource/order_remote_data_source.dart';
import 'package:uts_cargo/data/models/order_model/order_model.dart';
import 'package:uts_cargo/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource remote;

  OrderRepositoryImpl(this.remote);

  @override
  Future<List<OrderModel>> getOrder() async {
    return await remote.getOrder();
  }
}
