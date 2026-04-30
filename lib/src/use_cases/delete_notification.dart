import '../repositories/notification_repository.dart';

class DeleteNotification {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  Future<void> execute(int id) async {
    await repository.deleteNotification(id);
  }
}
