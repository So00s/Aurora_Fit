import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Инициализация уведомлений
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Укажите иконку уведомления
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Немедленное отображение уведомления
  Future<void> showNotification() async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'general_notifications', // Уникальный ID канала
        'General Notifications', // Имя канала
        channelDescription: 'Notifications about general app updates and news',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID уведомления
      'Напоминание', // Заголовок уведомления
      'Это уведомление появляется немедленно!', // Текст уведомления
      notificationDetails,
    );
  }
}

