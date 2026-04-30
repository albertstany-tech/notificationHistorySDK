import '../repositories/notification_repository.dart';

class MarkAllNotificationsAsRead {
  final NotificationRepository repository;

  MarkAllNotificationsAsRead(this.repository);

  Future<void> execute() async {
    await repository.markAllNotificationsAsRead();
  }
}
