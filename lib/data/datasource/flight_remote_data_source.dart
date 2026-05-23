import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/data/models/flight_model/flight_model.dart';

class FlightRemoteDataSource {
  final ApiClient client;

  FlightRemoteDataSource(this.client);

  Future<FlightListModel> getFlights({
    int page = 1,
    String? status,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (status != null && status != 'barchasi') params['status'] = status;

    final res = await client.get('/api/flights/', queryParams: params);

    final items = (res['results'] as List)
        .map((e) => FlightModel.fromJson(e))
        .toList();

    return FlightListModel(
      flights: items,
      totalCount: res['count'] ?? 0,
      nextPage: res['next'],
    );
  }
}
