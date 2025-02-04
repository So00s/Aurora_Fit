import 'package:flutter/material.dart';
import 'package:aurora_fit/pages/aurora_first_page.dart';
import 'services/notification_service.dart';

void main() async{
  await notification_service.init();
  runApp(const AuroraFitApp());
}

class AuroraFitApp extends StatelessWidget {
  const AuroraFitApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    notification_service(
    time(12, 44), // Планирует уведомление на 15:10
    message("Hello"), // Сообщение уведомления
  );
      notification_service(
    time(12, 46), // Планирует уведомление на 15:10
    message("Loh"), // Сообщение уведомления
  );
      notification_service(
    time(12, 48), // Планирует уведомление на 15:10
    message("Test"), // Сообщение уведомления
  );
    return MaterialApp(
      title: 'Aurora Fit',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AuroraFirstPage(),
    );
  }
}