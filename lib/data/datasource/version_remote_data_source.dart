import 'package:uts_cargo/core/network/api_client.dart';

import '../models/version_model/version_model.dart';

class VersionRemoteDataSource {
  final ApiClient apiClient;

  VersionRemoteDataSource(this.apiClient);

  Future<VersionModel> getAppVersion() async {
    final response = await apiClient.get('/api/services/app-version/');
    return VersionModel.fromJson(response);
  }
}