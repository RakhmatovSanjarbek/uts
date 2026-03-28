import '../../domain/repositories/warehouse_repository.dart';
import '../datasource/warehouse_remote_data_source.dart';
import '../models/warehouse/arrived_group_response.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseRemoteDataSource remote;
  WarehouseRepositoryImpl(this.remote);

  @override
  Future<List<ArrivedGroupResponse>> getArrivedGroups() async {
    return await remote.getArrivedGroups();
  }

  @override
  Future<void> setDelivery(int groupId, String method, String? address) async{
    return await remote.setDelivery(groupId, method, address);
  }

  @override
  Future<void> uploadPaymentCheck(int groupId, String filePaths) async{
    return await remote.uploadPaymentCheck(groupId, filePaths);
  }
}