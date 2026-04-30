import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_history/notification_history.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerSingleton<NotificationRepository>(
    SqfliteNotificationRepository.instance,
  );
  getIt.registerSingleton<AddNotification>(
    AddNotification(getIt<NotificationRepository>()),
  );
  getIt.registerSingleton<GetNotifications>(
    GetNotifications(getIt<NotificationRepository>()),
  );
  getIt.registerSingleton<MarkNotificationAsRead>(
    MarkNotificationAsRead(getIt<NotificationRepository>()),
  );
  getIt.registerSingleton<DeleteNotification>(
    DeleteNotification(getIt<NotificationRepository>()),
  );
  getIt.registerSingleton<MarkAllNotificationsAsRead>(
    MarkAllNotificationsAsRead(getIt<NotificationRepository>()),
  );
  getIt.registerSingleton<NotificationHandler>(
    NotificationHandler(addNotification: getIt<AddNotification>()),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDI();
  await getIt<NotificationHandler>().initialize();
  runApp(
    MyApp(
      getNotifications: getIt<GetNotifications>(),
      markNotificationAsRead: getIt<MarkNotificationAsRead>(),
      deleteNotification: getIt<DeleteNotification>(),
      markAllNotificationsAsRead: getIt<MarkAllNotificationsAsRead>(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  final DeleteNotification deleteNotification;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;

  const MyApp({
    super.key,
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.deleteNotification,
    required this.markAllNotificationsAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In-App Notification History',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Notification History Demo',
        getNotifications: getNotifications,
        markNotificationAsRead: markNotificationAsRead,
        deleteNotification: deleteNotification,
        markAllNotificationsAsRead: markAllNotificationsAsRead,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  final DeleteNotification deleteNotification;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;

  const MyHomePage({
    super.key,
    required this.title,
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.deleteNotification,
    required this.markAllNotificationsAsRead,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Test notifications:'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getIt<NotificationHandler>().showNotification(
                  'Test Notification',
                  'This is a test notification!',
                  payload: 'test_payload',
                );
              },
              child: const Text('Send Local Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationHistoryScreen(
                      getNotifications: widget.getNotifications,
                      markNotificationAsRead: widget.markNotificationAsRead,
                      deleteNotification: widget.deleteNotification,
                      markAllNotificationsAsRead:
                          widget.markAllNotificationsAsRead,
                    ),
                  ),
                );
              },
              child: const Text('View Notification History'),
            ),
          ],
        ),
      ),
    );
  }
}
