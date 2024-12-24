import 'package:flutter/material.dart';
import 'package:aurora_fit/pages/aurora_first_page.dart';
import 'package:path_provider/path_provider.dart';
import 'services/notification_service.dart';

final NotificationService notificationService = NotificationService();

void main() {
  runApp(const AuroraFitApp());
}

class AuroraFitApp extends StatelessWidget {
  const AuroraFitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Fit',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AuroraFirstPage(),
    );
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  final NotificationService notificationService;

  AppLifecycleObserver(this.notificationService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      notificationService.scheduleNotification(17, 37);
      notificationService.scheduleNotification(20, 39);
      notificationService.scheduleNotification(20, 38);
    }
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
    WidgetsBinding.instance.addObserver(AppLifecycleObserver(notificationService));
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}