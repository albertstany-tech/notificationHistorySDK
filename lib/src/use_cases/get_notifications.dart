import '../entities/notification_item.dart';
import '../repositories/notification_repository.dart';

/// A use case to retrieve notifications with pagination support.
class GetNotifications {
  /// The repository instance used to fetch notifications.
  final NotificationRepository repository;

  /// Creates a new [GetNotifications] use case.
  GetNotifications(this.repository);

  /// Executes the use case to fetch notifications.
  /// 
  /// The [limit] defines how many notifications to fetch, default is 50.
  /// The [offset] defines the starting point for fetching, default is 0.
  Future<List<NotificationItem>> execute({
    int limit = 50,
    int offset = 0,
  }) async {
    return await repository.getAllNotifications(limit: limit, offset: offset);
  }
}
