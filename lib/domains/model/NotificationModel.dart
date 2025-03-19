class NotificationModel {
  String notificationId;
  String userId;
  String message;
  bool isRead;
  DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "notification_id": notificationId,
      "user_id": userId,
      "message": message,
      "is_read": isRead,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map["notification_id"],
      userId: map["user_id"],
      message: map["message"],
      isRead: map["is_read"],
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}
