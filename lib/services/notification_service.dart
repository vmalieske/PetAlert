import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class NotificationService {
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'pet_alert',
        channelName: 'Pet Alert',
        channelDescription:
            'Benachrichtigung für Tiere, die alleine zuhause sind.',
        onlyAlertOnce: true,
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
      ),
    );
  }

  static Future<void> start({
    required String title,
    required String text,
    required Function() callback,
  }) async {
    await FlutterForegroundTask.requestNotificationPermission();
    final isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      await FlutterForegroundTask.restartService();
    } else {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
      await FlutterForegroundTask.startService(
        serviceId: 1,
        notificationTitle: title,
        notificationText: text,
        callback: callback,
      );
    }
  }

  static Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}
