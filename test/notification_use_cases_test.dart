import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notification_history/src/entities/notification_item.dart';
import 'package:notification_history/src/repositories/notification_repository.dart';
import 'package:notification_history/src/use_cases/add_notification.dart';
import 'package:notification_history/src/use_cases/delete_notification.dart';
import 'package:notification_history/src/use_cases/delete_old_notifications.dart';
import 'package:notification_history/src/use_cases/get_notifications.dart';
import 'package:notification_history/src/use_cases/mark_all_notifications_as_read.dart';
import 'package:notification_history/src/use_cases/mark_notification_as_read.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;
  late AddNotification addNotification;
  late GetNotifications getNotifications;
  late MarkNotificationAsRead markNotificationAsRead;
  late DeleteNotification deleteNotification;
  late MarkAllNotificationsAsRead markAllNotificationsAsRead;
  late DeleteOldNotifications deleteOldNotifications;

  setUp(() {
    mockRepository = MockNotificationRepository();
    addNotification = AddNotification(mockRepository);
    getNotifications = GetNotifications(mockRepository);
    markNotificationAsRead = MarkNotificationAsRead(mockRepository);
    deleteNotification = DeleteNotification(mockRepository);
    markAllNotificationsAsRead = MarkAllNotificationsAsRead(mockRepository);
    deleteOldNotifications = DeleteOldNotifications(mockRepository);
  });

  test('Add notification use case', () async {
    final notification = NotificationItem(
      id: 0,
      title: 'Test Title',
      body: 'Test Body',
      receivedAt: DateTime.now(),
      isRead: false,
    );

    when(mockRepository.addNotification(notification)).thenAnswer(
      (_) async => NotificationItem(
        id: 1,
        title: notification.title,
        body: notification.body,
        payload: notification.payload,
        receivedAt: notification.receivedAt,
        isRead: notification.isRead,
      ),
    );

    final result = await addNotification.execute(notification);
    expect(result.id, 1);
    expect(result.title, 'Test Title');
  });

  test('Get notifications use case', () async {
    final notifications = [
      NotificationItem(
        id: 1,
        title: 'Test',
        body: 'Body',
        receivedAt: DateTime.now(),
        isRead: false,
      ),
    ];

    when(
      mockRepository.getAllNotifications(limit: 50, offset: 0),
    ).thenAnswer((_) async => notifications);

    final result = await getNotifications.execute();
    expect(result.length, 1);
    expect(result.first.title, 'Test');
  });

  test('Mark notification as read use case', () async {
    when(mockRepository.markNotificationAsRead(1)).thenAnswer((_) async => {});

    await markNotificationAsRead.execute(1);
    verify(mockRepository.markNotificationAsRead(1)).called(1);
  });

  test('Delete notification use case', () async {
    when(mockRepository.deleteNotification(1)).thenAnswer((_) async => {});

    await deleteNotification.execute(1);
    verify(mockRepository.deleteNotification(1)).called(1);
  });

  test('Mark all notifications as read use case', () async {
    when(
      mockRepository.markAllNotificationsAsRead(),
    ).thenAnswer((_) async => {});

    await markAllNotificationsAsRead.execute();
    verify(mockRepository.markAllNotificationsAsRead()).called(1);
  });

  test('Delete old notifications use case', () async {
    final duration = Duration(days: 30);
    when(
      mockRepository.deleteNotificationsOlderThan(duration),
    ).thenAnswer((_) async => {});

    await deleteOldNotifications.execute(duration);
    verify(mockRepository.deleteNotificationsOlderThan(duration)).called(1);
  });
}
