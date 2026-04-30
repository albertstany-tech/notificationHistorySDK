import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

class AddNotification {
  final NotificationRepository repository;

  AddNotification(this.repository);

  Future<NotificationItem> execute(NotificationItem item) async {
    return await repository.addNotification(item);
  }
}
