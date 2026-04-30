import '../repositories/notification_repository.dart';

/// A use case to delete a notification by its ID.
class DeleteNotification {
  /// The repository instance used to delete the notification.
  final NotificationRepository repository;

  /// Creates a new [DeleteNotification] use case.
  DeleteNotification(this.repository);

  /// Executes the use case to delete a notification with the given [id].
  Future<void> execute(int id) async {
    await repository.deleteNotification(id);
  }
}
