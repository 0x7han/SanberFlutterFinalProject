import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'Local notification',
    'Rei POS',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    playSound: true,
    enableVibration: true,
  );

  static NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  Future<void> init() async {
    const initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: initAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> sendLocalNotification(int id, String body) async {
    await LocalNotificationHelper.flutterLocalNotificationsPlugin.show(
        id,
        "Rei POS",
        body,
        LocalNotificationHelper.notificationDetails);
  }
}
