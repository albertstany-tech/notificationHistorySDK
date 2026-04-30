import '../repositories/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  Future<void> execute(int id) async {
    await repository.markNotificationAsRead(id);
  }
}
