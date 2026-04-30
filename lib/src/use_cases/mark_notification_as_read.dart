import '../repositories/notification_repository.dart';

/// A use case to mark a specific notification as read.
class MarkNotificationAsRead {
  /// The repository instance used to mark the notification.
  final NotificationRepository repository;

  /// Creates a new [MarkNotificationAsRead] use case.
  MarkNotificationAsRead(this.repository);

  /// Executes the use case to mark the notification with the given [id] as read.
  Future<void> execute(int id) async {
    await repository.markNotificationAsRead(id);
  }
}
