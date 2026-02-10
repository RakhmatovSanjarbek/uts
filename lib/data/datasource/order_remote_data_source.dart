import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/data/models/order_model/order_model.dart';

import '../../core/constants/constants.dart';

class OrderRemoteDataSource{
  final ApiClient client;

  OrderRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<List<OrderModel>> getOrder() async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);

    final res = await apiClient.get("/api/cargo/my-cargos/");

    return (res as List)
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

}