import '../repositories/notification_repository.dart';

/// A use case to mark all stored notifications as read.
class MarkAllNotificationsAsRead {
  /// The repository instance used to mark notifications.
  final NotificationRepository repository;

  /// Creates a new [MarkAllNotificationsAsRead] use case.
  MarkAllNotificationsAsRead(this.repository);

  /// Executes the use case to mark all notifications as read.
  Future<void> execute() async {
    await repository.markAllNotificationsAsRead();
  }
}
