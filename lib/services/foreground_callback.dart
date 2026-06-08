import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(PetAlertTaskHandler());
}

class PetAlertTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('Start Task');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print('Stop Task');
  }

  @override
  void onNotificationDismissed() {
    FlutterForegroundTask.sendDataToMain('dismissed');
    FlutterForegroundTask.stopService();
  }
}
