import '../repositories/notification_repository.dart';

class DeleteOldNotifications {
  final NotificationRepository repository;

  DeleteOldNotifications(this.repository);

  Future<void> execute(Duration duration) async {
    await repository.deleteNotificationsOlderThan(duration);
  }
}
