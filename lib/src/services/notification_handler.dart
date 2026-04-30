import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../entities/notification_item.dart';
import '../use_cases/add_notification.dart';

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  AddNotification? _addNotification;

  NotificationHandler._();

  factory NotificationHandler({required AddNotification addNotification}) {
    _instance._addNotification = addNotification;
    return _instance;
  }

  AddNotification get addNotification => _addNotification!;

  static NotificationHandler get instance => _instance;

  Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Request FCM permissions
    await _firebaseMessaging.requestPermission();

    // Initialize local notifications
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          await _storeNotification(
            title: response.payload?.split('|')[0] ?? 'No Title',
            body: response.payload?.split('|')[1] ?? 'No Body',
            payload: response.payload,
          );
        }
      },
    );

    // Handle foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null) {
        await showNotification(
          notification.title ?? 'No Title',
          notification.body ?? 'No Body',
          payload: message.data.toString(),
        );
        await _storeFcmNotification(message);
      }
    });

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _storeNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final notification = NotificationItem(
      id: 0,
      title: title,
      body: body,
      payload: payload,
      receivedAt: DateTime.now(),
      isRead: false,
    );
    await addNotification.execute(notification);
  }

  Future<void> _storeFcmNotification(RemoteMessage message) async {
    final notification = NotificationItem(
      id: 0,
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      payload: message.data.toString(),
      receivedAt: DateTime.now(),
      isRead: false,
    );
    await addNotification.execute(notification);
  }

  Future<void> showNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch % 1000000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
    await _storeNotification(title: title, body: body, payload: payload);
  }
}

// Background handler for FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final handler = NotificationHandler
      .instance; // Note: Singleton instance, use case injection needed
  await handler._storeFcmNotification(message);
}
