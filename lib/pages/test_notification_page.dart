// lib/pages/aurora_first_page.dart

import 'package:flutter/material.dart';
import 'package:aurora_fit/pages/schedule_screen.dart';
import 'package:aurora_fit/pages/aurora_training_types_page.dart';
import 'package:aurora_fit/classes/gradient_button.dart';
import 'package:aurora_fit/classes/fractional_stars.dart';
import 'package:aurora_fit/services/notification_service.dart';
import 'package:aurora_fit/pages/training_description_screen.dart';
import 'package:aurora_fit/pages/choosing_of_training_screen.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class TestNotificationPage extends StatefulWidget {
  const TestNotificationPage({Key? key}) : super(key: key);

  @override
  _TestNotificationPageState createState() => _TestNotificationPageState();
}

class _TestNotificationPageState extends State<TestNotificationPage> {
  String _notificationTitle = 'Notification Title';
  String _notificationBody = 'Notification Body';
  DateTime? _scheduledTime;
  final int _notificationID = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // Инициализация плагина уведомлений для Linux
  Future<void> _initializeNotifications() async {
    const LinuxInitializationSettings linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      linux: linuxSettings,
    );

    await _notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );
  }

  // Обработчик нажатия на уведомление
  void _onSelectNotification(NotificationResponse response) {
    // Здесь можно обработать нажатие на уведомление, если необходимо
    // Например, открыть определенный экран приложения
    // Для Sailfish OS специфическая обработка может отличаться
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Уведомление нажато')),
    );
  }

  // Планирование уведомления с использованием Timer
  Future<void> _scheduleNotification() async {
    if (_formKey.currentState?.validate() == true && _scheduledTime != null) {
      final now = DateTime.now();
      DateTime scheduledDateTime = _scheduledTime!;

      if (scheduledDateTime.isBefore(now)) {
        // Если выбранное время уже прошло сегодня, планируем на завтра
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      final duration = scheduledDateTime.difference(now);

      // Отменяем предыдущий таймер, если он существует
      _notificationTimer?.cancel();

      _notificationTimer = Timer(duration, () {
        _showNotification();
      });

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Уведомление запланировано на: $scheduledDateTime')),
      );
    } else {
      if (_scheduledTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, выберите время уведомления')),
        );
      }
    }
  }

  // Отображение уведомления
  Future<void> _showNotification() async {
    await _notificationPlugin.show(
      _notificationID,
      _notificationTitle,
      _notificationBody,
      const NotificationDetails(
        linux: LinuxNotificationDetails(
        ),
      ),
      payload: 'Данные уведомления', // Опционально: данные, передаваемые при нажатии
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Уведомление показано')),
    );
  }

  // Отмена всех уведомлений и таймеров
  Future<void> _cancelNotification() async {
    await _notificationPlugin.cancelAll();
    _notificationTimer?.cancel();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Все уведомления отменены')),
    );
  }

  // Выбор времени для уведомления
  Future<void> _pickScheduleTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      DateTime scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      setState(() {
        _scheduledTime = scheduledDateTime;
      });
    }
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String scheduledTimeText = _scheduledTime != null
        ? _scheduledTime.toString()
        : 'Не запланировано';

    return MaterialApp(
      title: 'Sailfish Notifications',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sailfish Notifications'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Flutter плагин для локальных уведомлений на Sailfish OS.',
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 32.0),
                const Text('Введите детали уведомления и выберите время:'),
                const SizedBox(height: 16.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Заголовок'),
                        initialValue: _notificationTitle,
                        onChanged: (value) {
                          _notificationTitle = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите заголовок';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Тело уведомления'),
                        initialValue: _notificationBody,
                        onChanged: (value) {
                          _notificationBody = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите тело уведомления';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _pickScheduleTime,
                        child: const Text('Выбрать время уведомления'),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Уведомление запланировано на: $scheduledTimeText',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _scheduleNotification,
                        child: const Text('Запланировать уведомление'),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _cancelNotification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Отменить все уведомления'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}