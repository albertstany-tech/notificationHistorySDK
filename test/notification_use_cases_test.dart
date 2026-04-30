import 'package:flutter_test/flutter_test.dart';
import 'package:notification_history/src/entities/notification_item.dart';
import 'package:notification_history/src/repositories/notification_repository.dart';
import 'package:notification_history/src/use_cases/add_notification.dart';
import 'package:notification_history/src/use_cases/delete_notification.dart';
import 'package:notification_history/src/use_cases/delete_old_notifications.dart';
import 'package:notification_history/src/use_cases/get_notifications.dart';
import 'package:notification_history/src/use_cases/mark_all_notifications_as_read.dart';
import 'package:notification_history/src/use_cases/mark_notification_as_read.dart';

class FakeNotificationRepository implements NotificationRepository {
  List<NotificationItem> notifications = [];
  int addCalledCount = 0;
  int markAsReadCalledCount = 0;
  int deleteCalledCount = 0;
  int markAllAsReadCalledCount = 0;
  int deleteOldCalledCount = 0;

  @override
  Future<NotificationItem> addNotification(NotificationItem notification) async {
    addCalledCount++;
    final newNotif = NotificationItem(
      id: 1,
      title: notification.title,
      body: notification.body,
      payload: notification.payload,
      receivedAt: notification.receivedAt,
      isRead: notification.isRead,
    );
    notifications.add(newNotif);
    return newNotif;
  }

  @override
  Future<List<NotificationItem>> getAllNotifications({int limit = 50, int offset = 0}) async {
    return notifications;
  }

  Future<int> getUnreadNotificationCount() async {
    return notifications.where((e) => !e.isRead).length;
  }

  @override
  Future<void> markNotificationAsRead(int id) async {
    markAsReadCalledCount++;
  }

  @override
  Future<void> deleteNotification(int id) async {
    deleteCalledCount++;
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    markAllAsReadCalledCount++;
  }

  @override
  Future<void> deleteNotificationsOlderThan(Duration duration) async {
    deleteOldCalledCount++;
  }
}

void main() {
  late FakeNotificationRepository fakeRepository;
  late AddNotification addNotification;
  late GetNotifications getNotifications;
  late MarkNotificationAsRead markNotificationAsRead;
  late DeleteNotification deleteNotification;
  late MarkAllNotificationsAsRead markAllNotificationsAsRead;
  late DeleteOldNotifications deleteOldNotifications;

  setUp(() {
    fakeRepository = FakeNotificationRepository();
    addNotification = AddNotification(fakeRepository);
    getNotifications = GetNotifications(fakeRepository);
    markNotificationAsRead = MarkNotificationAsRead(fakeRepository);
    deleteNotification = DeleteNotification(fakeRepository);
    markAllNotificationsAsRead = MarkAllNotificationsAsRead(fakeRepository);
    deleteOldNotifications = DeleteOldNotifications(fakeRepository);
  });

  test('Add notification use case', () async {
    final notification = NotificationItem(
      id: 0,
      title: 'Test Title',
      body: 'Test Body',
      receivedAt: DateTime.now(),
      isRead: false,
    );

    final result = await addNotification.execute(notification);
    expect(result.id, 1);
    expect(result.title, 'Test Title');
    expect(fakeRepository.addCalledCount, 1);
  });

  test('Get notifications use case', () async {
    fakeRepository.notifications = [
      NotificationItem(
        id: 1,
        title: 'Test',
        body: 'Body',
        receivedAt: DateTime.now(),
        isRead: false,
      ),
    ];

    final result = await getNotifications.execute();
    expect(result.length, 1);
    expect(result.first.title, 'Test');
  });

  test('Mark notification as read use case', () async {
    await markNotificationAsRead.execute(1);
    expect(fakeRepository.markAsReadCalledCount, 1);
  });

  test('Delete notification use case', () async {
    await deleteNotification.execute(1);
    expect(fakeRepository.deleteCalledCount, 1);
  });

  test('Mark all notifications as read use case', () async {
    await markAllNotificationsAsRead.execute();
    expect(fakeRepository.markAllAsReadCalledCount, 1);
  });

  test('Delete old notifications use case', () async {
    final duration = Duration(days: 30);
    await deleteOldNotifications.execute(duration);
    expect(fakeRepository.deleteOldCalledCount, 1);
  });
}
