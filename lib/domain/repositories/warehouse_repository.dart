import '../../data/models/warehouse/arrived_group_response.dart';

abstract class WarehouseRepository {
  Future<List<ArrivedGroupResponse>> getArrivedGroups();
  Future<void> uploadPaymentCheck(int groupId, String filePaths);
  Future<void> setDelivery(int groupId, String method, String? address);
}