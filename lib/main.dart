import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}
