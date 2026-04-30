import '../entities/notification_item.dart';

abstract class NotificationRepository {
  Future<NotificationItem> addNotification(NotificationItem item);
  Future<List<NotificationItem>> getAllNotifications({
    int limit = 50,
    int offset = 0,
  });
  Future<void> markNotificationAsRead(int id);
  Future<void> deleteNotification(int id);
  Future<void> markAllNotificationsAsRead();
  Future<void> deleteNotificationsOlderThan(Duration duration);
}
