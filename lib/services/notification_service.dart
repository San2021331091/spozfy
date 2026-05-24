import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ================= INIT =================
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    // initialize takes the settings as a NAMED argument
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap here. response.payload is available.
      },
    );
  }

  // ================= SHOW SINGLE NOTIFICATION =================
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'match_channel',
      'Match Notifications',
      channelDescription: 'Notifications for cricket matches',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  // ================= SHOW LATEST 3 =================
  static Future<void> showLatestThree(List<dynamic> matches) async {
    final latest3 = matches.take(3).toList();

    int id = 1;

    for (var match in latest3) {
      await _plugin.show(
        id: id++,
        title: match['name'] ?? "Match Update",
        body: match['status'] ?? "Live / Finished",
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'match_channel',
            'Match Notifications',
            channelDescription: 'Notifications for cricket matches',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }
}