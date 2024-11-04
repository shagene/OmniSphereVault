import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initialize() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
    );

    await _notifications.initialize(initializationSettings);
  }

  Future<void> showPasswordExpirationNotification(String title, String password) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'password_expiration',
        'Password Expiration',
        channelDescription: 'Notifications for password expiration',
        importance: Importance.high,
        priority: Priority.high,
      ),
      linux: LinuxNotificationDetails(),
    );

    await _notifications.show(
      0,
      'Password Expiration Warning',
      'The password for "$title" will expire soon',
      notificationDetails,
    );
  }
} 