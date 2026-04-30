import '../repositories/notification_repository.dart';

/// A use case to delete notifications older than a given duration.
class DeleteOldNotifications {
  /// The repository instance used to delete old notifications.
  final NotificationRepository repository;

  /// Creates a new [DeleteOldNotifications] use case.
  DeleteOldNotifications(this.repository);

  /// Executes the use case to delete notifications older than [duration].
  Future<void> execute(Duration duration) async {
    await repository.deleteNotificationsOlderThan(duration);
  }
}
