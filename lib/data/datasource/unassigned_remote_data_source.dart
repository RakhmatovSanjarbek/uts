import 'package:uts_cargo/core/network/api_client.dart';

import '../models/unassigned_model/unassigned_model.dart';

class UnassignedRemoteDataSource {
  final ApiClient client;

  UnassignedRemoteDataSource(this.client);

  Future<UnassignedCargoListModel> getUnassignedCargos({
    int page = 1,
    String? search,
  }) async {
    // Bu API ochiq — token shart emas
    final params = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) params['search'] = search;

    final res = await client.get(
      '/api/unassigned/',
      queryParams: params,
    );

    final items = (res['results'] as List)
        .map((e) => UnassignedCargoModel.fromJson(e))
        .toList();

    return UnassignedCargoListModel(
      items: items,
      totalCount: res['count'] ?? 0,
      nextPage: res['next'],
    );
  }
}