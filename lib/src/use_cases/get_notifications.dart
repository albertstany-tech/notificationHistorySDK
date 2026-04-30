import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationItem>> execute({
    int limit = 50,
    int offset = 0,
  }) async {
    return await repository.getAllNotifications(limit: limit, offset: offset);
  }
}
