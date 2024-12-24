import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Инициализация уведомлений
  Future<void> initializeNotifications() async {
    tzdata.initializeTimeZones();
    var initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      // Добавьте настройки для других платформ, если нужно
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Планирование уведомлений (платформонезависимое решение)
  Future<void> scheduleNotification(int hour, int minute) async {
    final location = tz.getLocation('UTC'); // Используем UTC для платформонезависимости

    // Создаем время уведомления
    final notificationTime = tz.TZDateTime(
      location,
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
    );

    // Если время уведомления уже прошло, перенесем его на следующий день
    if (notificationTime.isBefore(tz.TZDateTime.now(location))) {
      notificationTime.add(Duration(days: 1));
    }

    // Настройки уведомления (общие для всех платформ)
    var notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      // Добавьте настройки для других платформ, если нужно
    );

    // Планируем уведомление (платформонезависимый код)
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Напоминание',
      'Это уведомление будет отправлено в указанное время.',
      notificationTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }
}
