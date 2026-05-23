import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'models/alert_data.dart';
import 'models/hive_registrar.g.dart';
import 'services/notification_service.dart';
import 'screens/home.dart';
import 'providers/alert_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<AlertData>('alerts');
  NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlertProvider(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE53935),
          ).copyWith(primary: const Color(0xFFE53935), onPrimary: Colors.white),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
