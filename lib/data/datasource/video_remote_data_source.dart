import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/data/models/video_model/video_model.dart';

import '../../core/constants/constants.dart';

class VideoRemoteDataSource {
  final ApiClient client;

  VideoRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<List<VideoModel>> getVideo() async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);
    final res = await apiClient.get("/api/services/videos/");

    return (res as List).map((e) => VideoModel.fromJson(e)).toList();
  }
}
