# Notification History
A Flutter package for managing and displaying push notification history using Firebase Cloud Messaging (FCM) and local notifications.

# Features
Store notifications in a local SQLite database.
Display notification history with read/unread status.
Support for FCM and local notifications.
Clean architecture with dependency injection using get_it.

# Installation
1. Add the package to your pubspec.yaml:
```bash
dependencies:
  notification_history:
    path: /path/to/notification_history # For local development
    # Or use: git: https://github.com/AlbertStany/PushNotificationHistoryPackageFlutter
    # Or use: version: ^1.0.2
```

2. Run flutter pub get.

## Setup

1. Configure Firebase:

Add google-services.json to android/app/ and GoogleService-Info.plist to ios/Runner/.
Initialize Firebase in your app:
```bash
await Firebase.initializeApp();
```

2. Set Up Dependency Injection:
```bash
import 'package:get_it/get_it.dart';
import 'package:notification_history/notification_history.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerSingleton<NotificationRepository>(SqfliteNotificationRepository.instance);
  getIt.registerSingleton<AddNotification>(AddNotification(getIt<NotificationRepository>()));
  getIt.registerSingleton<GetNotifications>(GetNotifications(getIt<NotificationRepository>()));
  getIt.registerSingleton<MarkNotificationAsRead>(MarkNotificationAsRead(getIt<NotificationRepository>()));
  getIt.registerSingleton<DeleteNotification>(DeleteNotification(getIt<NotificationRepository>()));
  getIt.registerSingleton<MarkAllNotificationsAsRead>(MarkAllNotificationsAsRead(getIt<NotificationRepository>()));
  getIt.registerSingleton<NotificationHandler>(
    NotificationHandler._init(
      addNotification: getIt<AddNotification>(),
      channelId: 'your_channel_id',
      channelName: 'Your Channel Name',
      androidIcon: '@mipmap/your_icon',
    ),
  );
}
```

3. Initialize Notifications:
```bash
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDI();
  await getIt<NotificationHandler>().initialize();
  runApp(MyApp());
}
```

4. Display Notification History:
```bash
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationHistoryScreen(
      getNotifications: getIt<GetNotifications>(),
      markNotificationAsRead: getIt<MarkNotificationAsRead>(),
      deleteNotification: getIt<DeleteNotification>(),
      markAllNotificationsAsRead: getIt<MarkAllNotificationsAsRead>(),
    ),
  ),
);
```

5. Show a Local Notification:
```bash
getIt<NotificationHandler>().showNotification(
  'Test Title',
  'Test Body',
  payload: 'test_payload',
);
```

6. Android Configuration

Add to android/app/src/main/AndroidManifest.xml:
```bash
<application ...>
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_channel_id"
        android:value="your_channel_id" />
</application>
```

Add to android/app/src/main/res/values/strings.xml:
```bash
<resources>
    <string name="default_notification_channel_name">Your Channel Name</string>
</resources>
```

7. iOS Configuration

Enable Push Notifications in Xcode.
Add GoogleService-Info.plist to ios/Runner/.

# Example
See the example/ directory for a sample app.

# License
MIT License
