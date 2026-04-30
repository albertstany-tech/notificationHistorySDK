import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

/// A use case to add a new notification to the repository.
class AddNotification {
  /// The repository instance used to add the notification.
  final NotificationRepository repository;

  /// Creates a new [AddNotification] use case.
  AddNotification(this.repository);

  /// Executes the use case to add the [item] to the repository.
  Future<NotificationItem> execute(NotificationItem item) async {
    return await repository.addNotification(item);
  }
}
