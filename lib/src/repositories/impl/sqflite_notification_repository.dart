import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../entities/notification_item.dart';
import '../notification_repository.dart';

class SqfliteNotificationRepository implements NotificationRepository {
  static final SqfliteNotificationRepository instance =
      SqfliteNotificationRepository._init();
  static Database? _database;
  static const String tableNotifications = 'notifications';

  SqfliteNotificationRepository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNotifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        payload TEXT,
        receivedAt TEXT NOT NULL,
        isRead INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_receivedAt ON $tableNotifications (receivedAt)
    ''');
  }

  @override
  Future<NotificationItem> addNotification(NotificationItem item) async {
    try {
      final db = await database;
      final map = item.toMap()
        ..remove('id'); // Remove id to let SQLite auto-increment
      final id = await db.insert(tableNotifications, map);
      return NotificationItem(
        id: id,
        title: item.title,
        body: item.body,
        payload: item.payload,
        receivedAt: item.receivedAt,
        isRead: item.isRead,
      );
    } catch (e) {
      debugPrint('Error inserting notification: $e');
      rethrow;
    }
  }

  @override
  Future<List<NotificationItem>> getAllNotifications({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final db = await database;
      final result = await db.query(
        tableNotifications,
        orderBy: 'receivedAt DESC',
        limit: limit,
        offset: offset,
      );
      return result.map((map) => NotificationItem.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error retrieving notifications: $e');
      return [];
    }
  }

  @override
  Future<void> markNotificationAsRead(int id) async {
    try {
      final db = await database;
      await db.update(
        tableNotifications,
        {'isRead': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  @override
  Future<void> deleteNotification(int id) async {
    try {
      final db = await database;
      await db.delete(tableNotifications, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      final db = await database;
      await db.update(tableNotifications, {'isRead': 1});
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  @override
  Future<void> deleteNotificationsOlderThan(Duration duration) async {
    try {
      final db = await database;
      final cutoff = DateTime.now().subtract(duration).toIso8601String();
      await db.delete(
        tableNotifications,
        where: 'receivedAt < ?',
        whereArgs: [cutoff],
      );
    } catch (e) {
      debugPrint('Error deleting old notifications: $e');
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      _database = null;
      await db.close();
    } catch (e) {
      debugPrint('Error closing database: $e');
    }
  }
}
