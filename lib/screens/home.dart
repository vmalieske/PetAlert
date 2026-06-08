import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../services/notification_service.dart';
import '../services/foreground_callback.dart';
import '../providers/alert_provider.dart';
import 'overview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isRunning = false;

  final List<Widget> _screens = [
    const OverviewScreen(),
    const Center(child: Text('Einstellungen')),
  ];

  ReceivePort? _receivePort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkServiceStatus();
    _registerReceivePort();
  }

  void _registerReceivePort() {
    _receivePort = FlutterForegroundTask.receivePort;
    _receivePort?.listen((message) {
      if (message == 'dismissed') {
        _checkServiceStatus();
      }
    });
  }

  @override
  void dispose() {
    _receivePort?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkServiceStatus();
    }
  }

  Future<void> _checkServiceStatus() async {
    final running = await FlutterForegroundTask.isRunningService;
    if (mounted) setState(() => _isRunning = running);
  }

  Future<void> _toggle() async {
    final data = context.read<AlertProvider>().defaultDataset;
    if (_isRunning) {
      await NotificationService.stop();
    } else {
      await NotificationService.start(
        title: data.notificationTitle,
        text: data.notificationText,
        callback: startCallback,
      );
    }
    await _checkServiceStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          'assets/images/Pet_alert_Banner.png',
          width: 300,
          fit: BoxFit.fitWidth,
        ),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggle,
        backgroundColor: _isRunning ? Colors.red.shade100 : null,
        foregroundColor: _isRunning ? Colors.red : null,
        label: Text(_isRunning ? 'Deaktivieren' : 'Aktivieren'),
        icon: Icon(_isRunning ? Icons.stop : Icons.pets),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () => setState(() => _currentIndex = 0),
              color: _currentIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => setState(() => _currentIndex = 1),
              color: _currentIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
