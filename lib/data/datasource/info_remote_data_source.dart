import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import '../../core/network/api_client.dart';
import '../models/info_model/info_model.dart';

class InfoRemoteDataSource {
  final ApiClient client;

  InfoRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<InfoModel> getInfo() async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);
    final res = await apiClient.get("/api/services/services-info/");

    return InfoModel.fromJson(res as Map<String, dynamic>);
  }
}