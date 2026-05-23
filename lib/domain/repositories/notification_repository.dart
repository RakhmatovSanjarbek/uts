
import '../../data/models/notification_model /notification_model.dart';

abstract class NotificationRepository {
  Future<NotificationListModel> getNotifications({int page = 1});
  Future<void> markAsRead(int notificationId);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
}