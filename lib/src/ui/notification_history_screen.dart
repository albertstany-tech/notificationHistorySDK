import 'dart:async';
import 'package:flutter/material.dart';
import '../entities/notification_item.dart';
import '../use_cases/get_notifications.dart';
import '../use_cases/mark_notification_as_read.dart';
import '../use_cases/delete_notification.dart';
import '../use_cases/mark_all_notifications_as_read.dart';

class NotificationHistoryScreen extends StatefulWidget {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  final DeleteNotification deleteNotification;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;
  final bool showUnreadOnly;

  const NotificationHistoryScreen({
    Key? key,
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.deleteNotification,
    required this.markAllNotificationsAsRead,
    this.showUnreadOnly = false,
  }) : super(key: key);

  @override
  _NotificationHistoryScreenState createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  List<NotificationItem> _notifications = [];
  late StreamSubscription<List<NotificationItem>> _subscription;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _subscription = Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) => widget.getNotifications.execute())
        .listen((notifications) {
          setState(() {
            _notifications = widget.showUnreadOnly
                ? notifications.where((n) => !n.isRead).toList()
                : notifications;
          });
        });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    final notifications = await widget.getNotifications.execute();
    setState(() {
      _notifications = widget.showUnreadOnly
          ? notifications.where((n) => !n.isRead).toList()
          : notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () async {
              await widget.markAllNotificationsAsRead.execute();
              await _loadNotifications();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Dismissible(
            key: Key(notification.id.toString()),
            onDismissed: (direction) async {
              await widget.deleteNotification.execute(notification.id!);
              setState(() {
                _notifications.removeAt(index);
              });
            },
            background: Container(
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
            ),
            child: ListTile(
              title: Text(notification.title),
              subtitle: Text(notification.body),
              trailing: notification.isRead
                  ? null
                  : const Icon(Icons.circle, color: Colors.blue, size: 12),
              onTap: () async {
                await widget.markNotificationAsRead.execute(notification.id!);
                await _loadNotifications();
              },
            ),
          );
        },
      ),
    );
  }
}
