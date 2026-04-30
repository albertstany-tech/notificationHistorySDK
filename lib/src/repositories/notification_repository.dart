import '../entities/notification_item.dart';

/// An abstract repository interface for managing notification history.
abstract class NotificationRepository {
  /// Adds a new [item] to the repository and returns the saved item.
  Future<NotificationItem> addNotification(NotificationItem item);

  /// Retrieves a list of notifications, ordered by descending received time.
  /// Pagination is supported via [limit] and [offset].
  Future<List<NotificationItem>> getAllNotifications({
    int limit = 50,
    int offset = 0,
  });

  /// Marks a specific notification with the given [id] as read.
  Future<void> markNotificationAsRead(int id);

  /// Deletes a specific notification by its [id].
  Future<void> deleteNotification(int id);

  /// Marks all stored notifications as read.
  Future<void> markAllNotificationsAsRead();

  /// Deletes all notifications that are older than the specified [duration].
  Future<void> deleteNotificationsOlderThan(Duration duration);
}
