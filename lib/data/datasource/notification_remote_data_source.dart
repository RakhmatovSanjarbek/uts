import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_cargo/core/network/api_client.dart';
import 'package:uts_cargo/core/constants/constants.dart';

import '../models/notification_model /notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient client;

  NotificationRemoteDataSource(this.client);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.token);
  }

  Future<NotificationListModel> getNotifications({int page = 1}) async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);

    final res = await apiClient.get("/api/notifications/?page=$page");

    final results = res['results'] as Map<String, dynamic>;
    final items = (results['results'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();

    return NotificationListModel(
      notifications: items,
      unreadCount: results['unread_count'] ?? 0,
      totalCount: res['count'] ?? 0,
      nextPage: res['next'],
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);
    await apiClient.post("/api/notifications/$notificationId/read/", body: {});
  }

  Future<void> markAllAsRead() async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);
    await apiClient.post("/api/notifications/read-all/", body: {});
  }

  Future<int> getUnreadCount() async {
    final token = await getToken();
    final apiClient = ApiClient(token: token);
    final res = await apiClient.get("/api/notifications/unread-count/");
    return res['unread_count'] ?? 0;
  }
}