import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> showNotification(String title, String body) async {
    var android = AndroidNotificationDetails('id', 'name', importance: Importance.max);
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform);
  }
}
