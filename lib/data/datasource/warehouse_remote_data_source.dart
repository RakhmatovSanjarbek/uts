import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import '../../core/network/api_client.dart';
import '../models/warehouse/arrived_group_response.dart';

class WarehouseRemoteDataSource {
  final ApiClient client;
  WarehouseRemoteDataSource(this.client);

  Future<List<ArrivedGroupResponse>> getArrivedGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.token);
    final clientWithToken = ApiClient(token: token);

    final res = await clientWithToken.get('/api/warehouse/my-arrived-groups/');
    return (res as List).map((e) => ArrivedGroupResponse.fromJson(e)).toList();
  }

  Future<void> uploadPaymentCheck(int groupId, String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.token);
    final clientWithToken = ApiClient(token: token);

    FormData formData = FormData.fromMap({
      'payment_check': await MultipartFile.fromFile(filePath),
    });

    await clientWithToken.post(
      '${Constants.baseUrl}/api/warehouse/groups/$groupId/upload-check/',
      body: formData,
    );
  }
  Future<void> setDelivery(int groupId, String method, String? address) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constants.token);
    final clientWithToken = ApiClient(token: token);

    await clientWithToken.post(
      '/api/warehouse/groups/$groupId/set-delivery/',
      body: {
        "delivery_method": method,
        "delivery_address": address ?? "",
      },
    );
  }
}