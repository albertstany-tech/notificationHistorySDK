class NotificationItem {
  final int? id; // Nullable to allow auto-increment
  final String title;
  final String body;
  final String? payload;
  final DateTime receivedAt;
  final bool isRead;

  NotificationItem({
    this.id,
    required this.title,
    required this.body,
    this.payload,
    required this.receivedAt,
    required this.isRead,
  });

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
