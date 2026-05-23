import 'package:uts_cargo/data/datasource/notification_remote_data_source.dart';
import 'package:uts_cargo/domain/repositories/notification_repository.dart';

import '../models/notification_model /notification_model.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<NotificationListModel> getNotifications({int page = 1}) async {
    return await remote.getNotifications(page: page);
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    return await remote.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    return await remote.markAllAsRead();
  }

  @override
  Future<int> getUnreadCount() async {
    return await remote.getUnreadCount();
  }
}