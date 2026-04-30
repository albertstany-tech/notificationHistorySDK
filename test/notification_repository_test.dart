import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notification_history/src/entities/notification_item.dart';
import 'package:notification_history/src/repositories/impl/sqflite_notification_repository.dart';

void main() {
  group('SqfliteNotificationRepository Tests', () {
    late SqfliteNotificationRepository repository;

    setUp(() async {
      repository = SqfliteNotificationRepository.instance;
      // Sqflite.setMockDatabaseFactory(MockDatabaseFactory());
    });

    tearDown(() async {
      await repository.close();
    });

    test('Add and retrieve notification', () async {
      final notification = NotificationItem(
        id: 0,
        title: 'Test Title',
        body: 'Test Body',
        receivedAt: DateTime.now(),
        isRead: false,
      );

      final added = await repository.addNotification(notification);
      final retrieved = await repository.getAllNotifications();

      expect(retrieved.length, 1);
      expect(retrieved.first.title, 'Test Title');
      expect(retrieved.first.body, 'Test Body');
      expect(retrieved.first.isRead, false);
    });

    test('Mark notification as read', () async {
      final notification = NotificationItem(
        id: 0,
        title: 'Test Title',
        body: 'Test Body',
        receivedAt: DateTime.now(),
        isRead: false,
      );

      final added = await repository.addNotification(notification);
      await repository.markNotificationAsRead(added.id!);
      final retrieved = await repository.getAllNotifications();

      expect(retrieved.first.isRead, true);
    });

    test('Delete notification', () async {
      final notification = NotificationItem(
        id: 0,
        title: 'Test Title',
        body: 'Test Body',
        receivedAt: DateTime.now(),
        isRead: false,
      );

      final added = await repository.addNotification(notification);
      await repository.deleteNotification(added.id!);
      final retrieved = await repository.getAllNotifications();

      expect(retrieved.length, 0);
    });
  });
}

// Mock Database Factory for Testing
class MockDatabaseFactory extends Mock implements DatabaseFactory {}
