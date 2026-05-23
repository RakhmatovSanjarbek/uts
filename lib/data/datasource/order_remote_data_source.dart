import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/data/models/order_model/order_model.dart';
import '../../core/constants/constants.dart';

class OrderListModel {
  final List<OrderModel> orders;
  final int totalCount;
  final String? nextPage;
  final int currentPage;

  OrderListModel({
    required this.orders,
    required this.totalCount,
    this.nextPage,
    required this.currentPage,
  });
}

class OrderRemoteDataSource {
  final ApiClient client;

  OrderRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<OrderListModel> getOrders({
    int page = 1,
    String? search,
    String? status,
  }) async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);

    final params = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (status != null && status != 'Barchasi') params['status'] = status;

    final res = await apiClient.get(
      "/api/cargo/my-cargos/",
      queryParams: params,
    );

    final items = (res['results'] as List)
        .map((e) => OrderModel.fromJson(e))
        .toList();

    return OrderListModel(
      orders: items,
      totalCount: res['count'] ?? 0,
      nextPage: res['next'],
      currentPage: page,
    );
  }
}