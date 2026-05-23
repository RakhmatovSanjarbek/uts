class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String notificationType;
  final int? cargoId;
  final String? trackCode;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.notificationType,
    this.cargoId,
    this.trackCode,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      notificationType: json['notification_type'] ?? 'Umumiy',
      cargoId: json['cargo_id'],
      trackCode: json['track_code'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      notificationType: notificationType,
      cargoId: cargoId,
      trackCode: trackCode,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

class NotificationListModel {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int totalCount;
  final String? nextPage;

  NotificationListModel({
    required this.notifications,
    required this.unreadCount,
    required this.totalCount,
    this.nextPage,
  });
}