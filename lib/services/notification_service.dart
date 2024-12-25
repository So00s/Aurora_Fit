// lib/services/notification_service.dart

import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Вспомогательная функция для создания времени уведомления
DateTime time(int hour, int minute) {
  final now = DateTime.now();
  DateTime scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    // Если время уже прошло сегодня, планируем на завтра
    scheduledDate = scheduledDate.add(Duration(days: 1));
  }
  return scheduledDate;
}

/// Вспомогательная функция для создания сообщения уведомления
String message(String msg) => msg;

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _notificationIdCounter = 1;

  final Map<int, Timer> _activeTimers = {};

  /// Инициализация сервиса уведомлений
  Future<void> init() async {
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open',
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      linux: initializationSettingsLinux,
      // Добавьте другие платформенные настройки, если необходимо
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    print('NotificationService инициализирован');
  }

  /// Обработчик нажатия на уведомление
  void _onSelectNotification(NotificationResponse response) {
    // Здесь можно определить действия при нажатии на уведомление
    // Например, навигация к определённому экрану
    print('Уведомление нажато с payload: ${response.payload}');
    // Реализуйте логику навигации или другие действия здесь
  }

  /// Метод call для вызова сервиса как функции
  Future<void> call(DateTime scheduledDate, String message) async {
    await scheduleNotification(
      scheduledDate: scheduledDate,
      title: 'Напоминание',
      body: message,
      payload: 'Default_Payload',
    );
  }

  /// Планирование уведомления на конкретное время
  Future<void> scheduleNotification({
    required DateTime scheduledDate,
    required String title,
    required String body,
    String? payload,
  }) async {
    final DateTime now = DateTime.now();

    if (scheduledDate.isBefore(now)) {
      print('Запланированное время уже прошло: $scheduledDate');
      return;
    }

    final Duration delay = scheduledDate.difference(now);

    // Генерация уникального ID уведомления
    final int id = _notificationIdCounter++;

    // Отменяем предыдущий таймер с таким ID, если он существует
    _activeTimers[id]?.cancel();

    // Планируем Timer для отображения уведомления
    Timer timer = Timer(delay, () {
      _showNotification(id, title, body, payload);
      _activeTimers.remove(id);
    });

    // Сохраняем Timer для возможного управления
    _activeTimers[id] = timer;

    print('Уведомление запланировано на: $scheduledDate с ID: $id');
  }

  /// Отображение уведомления
  Future<void> _showNotification(
      int id, String title, String body, String? payload) async {
    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxNotificationDetails,
      // Добавьте другие платформенные настройки, если необходимо
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    print('Уведомление показано: $title - $body с ID: $id');
  }

  /// Отмена конкретного уведомления по ID
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    _activeTimers[id]?.cancel();
    _activeTimers.remove(id);
    print('Уведомление с ID: $id отменено');
  }

  /// Отмена всех уведомлений и таймеров
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    _activeTimers.forEach((id, timer) => timer.cancel());
    _activeTimers.clear();
    print('Все уведомления отменены');
  }

  /// Dispose всех таймеров при необходимости
  void dispose() {
    _activeTimers.forEach((id, timer) => timer.cancel());
    _activeTimers.clear();
    print('NotificationService disposed');
  }
}

// Экземпляр сервиса для удобного использования
final notification_service = NotificationService();