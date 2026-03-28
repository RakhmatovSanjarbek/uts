import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';

import '../../core/constants/constants.dart';
import '../models/calculator_model/calculator_request.dart';
import '../models/calculator_model/calculator_response.dart';

class CalculatorRemoteDataSource {
  final ApiClient client;

  CalculatorRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<List<CalculatorResponse>> getCalculations() async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);

    final res = await clientWithToken.get('/api/services/calculator/');
    return (res as List)
        .map((json) => CalculatorResponse.fromJson(json))
        .toList();
  }

  Future<CalculatorResponse> createCalculation(
    CalculatorRequest request,
  ) async {
    final token = await getToken();
    final clientWithToken = ApiClient(token: token);
    final body = await request.toFormData();

    final res = await clientWithToken.post(
      '/api/services/calculator/',
      body: body,
      isMultipart: true,
    );
    return CalculatorResponse.fromJson(res);
  }
}
