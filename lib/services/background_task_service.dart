import 'package:mogrow/services/notification_scheduler.dart';
import 'package:workmanager/workmanager.dart';

const String taskCheckNotifications = 'checkNotifications';
const String taskUpdateNotifications = 'updateNotifications';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('🔔 Background task started: $task');

      // 알림 데이터만 계산 (알림 발송 x)
      await NotificationScheduler.calculateTomorrowNotifications();

      print('✅ Background task completed');
      return Future.value(true);
    } catch (e) {
      print('❌ Background task error: $e');
      return Future.value(false);
    }
  });
}

class BackgroundTaskService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // 개발 중에는 true로
    );

    // 매일 11시 실행 (다음날 알람 준비)
    await Workmanager().registerPeriodicTask(
      'calculate-notifications',
      taskUpdateNotifications,
      frequency: Duration(hours: 24),
      initialDelay: _calculateDelay(23, 0), // 밤 11시
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );

    // 테스트용; 1분뒤 실행
    await Workmanager().registerPeriodicTask(
      'test-calculate',
      taskCheckNotifications,
      initialDelay: const Duration(minutes: 1),
    );

    print('✅ WorkManager initialized');
  }

  static Duration _calculateDelay(int hour, int minute) {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, hour, minute);

    if (target.isBefore(now)) {
      target = target.add(Duration(days: 1));
    }

    return target.difference(now);
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
    print('❌ All background tasks cancelled');
  }
}
