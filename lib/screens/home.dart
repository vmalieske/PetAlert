import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/foreground_callback.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Einstellungen')),
    const Center(child: Text('Info')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => NotificationService.start(
          title: 'Bei Freund Peter wartet Hund Bello',
          text: 'Notfallkontakt: Mama · 0123 456789',
          callback: startCallback,
        ),
        label: const Text('Aktivieren'),
        icon: const Icon(Icons.pets),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => setState(() => _currentIndex = 0),
              color: _currentIndex == 0 ? Theme.of(context).primaryColor : null,
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => setState(() => _currentIndex = 1),
              color: _currentIndex == 1 ? Theme.of(context).primaryColor : null,
            ),
          ],
        ),
      ),
    );
  }
}
