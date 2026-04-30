/// Represents a single push notification stored in the local history.
class NotificationItem {
  /// The unique identifier of the notification, nullable for auto-increment.
  final int? id;

  /// The title of the notification.
  final String title;

  /// The body text of the notification.
  final String body;

  /// Optional payload data attached to the notification.
  final String? payload;

  /// The timestamp when the notification was received.
  final DateTime receivedAt;

  /// Indicates whether the notification has been read by the user.
  final bool isRead;

  /// Creates a new [NotificationItem].
  NotificationItem({
    this.id,
    required this.title,
    required this.body,
    this.payload,
    required this.receivedAt,
    required this.isRead,
  });

  /// Converts this [NotificationItem] into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'receivedAt': receivedAt.toIso8601String(),
      'isRead': isRead ? 1 : 0,
    };
  }

  /// Creates a [NotificationItem] from a Map retrieved from the database.
  factory NotificationItem.fromMap(Map<String, dynamic> source) {
    return NotificationItem(
      id: source['id'] as int?,
      title: source['title'] as String,
      body: source['body'] as String,
      payload: source['payload'] as String?,
      receivedAt: DateTime.parse(source['receivedAt'] as String),
      isRead: (source['isRead'] as int) == 1,
    );
  }
}
