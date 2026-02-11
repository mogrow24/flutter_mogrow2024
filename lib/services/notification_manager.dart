import 'package:mogrow/services/notification_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

enum NotificationType {
  incompleteTasks(1, 18, 0), // 할일 미완료
  unregisteredTasks(2, 8, 0), // 할일 미등록
  noRecords(3, 21, 0), // 기록 안함
  dDay(10, 0, 0), // 디데이
  projectDays(11, 0, 0), // D+일정
  threeDaysNoLogin(12, 0, 0), // 3일 미접속
  oneDayNoLogin(13, 0, 0); // 1일 미접속

  final int id;
  final int hour;
  final int minute;

  const NotificationType(this.id, this.hour, this.minute);
}

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final NotificationService _notificationService = NotificationService();

  // 모든 알림 설정
  Future<void> setupAllNotifications() async {
    await _notificationService.initialize();

    // 일일 반복 알림들 설정
    await _setupDailyNotifications();

    // 저장된 알림 데이터 읽어서 에약

    print('📱 All notifications setup completed');
  }

  // 일일 반복 알림 설정
  Future<void> _setupDailyNotifications() async {
    // 할일 미등록 체크 (08:00)
    await _notificationService.scheduleDailyNotification(
      id: NotificationType.unregisteredTasks.id,
      title: '오늘의 할 일 등록',
      body: '오늘의 할 일을 등록해 주세요.',
      hour: NotificationType.unregisteredTasks.hour,
      minute: NotificationType.unregisteredTasks.minute,
    );

    // 기록 안한 경우 체크 (21:00)
    await _notificationService.scheduleDailyNotification(
      id: NotificationType.noRecords.id,
      title: '오늘의 기록',
      body: '오늘 한 일들에 대해 기록을 남겨보세요.',
      hour: NotificationType.noRecords.hour,
      minute: NotificationType.noRecords.minute,
    );

    print('✅ Daily notifications scheduled');
  }

  // ✅ 저장된 알림 데이터 읽어서 실제 알림 예약
  Future<void> scheduleStoredNotifications() async {
    try {
      print('📅 Scheduling stored notifications...');

      final notifications =
          await NotificationScheduler.getStoredNotifications();

      if (notifications == null || notifications.isEmpty) {
        print('ℹ️  No stored notifications');
        return;
      }

      int scheduled = 0;
      for (var notification in notifications) {
        // 이미 지난 시간이면 스킵
        if (notification.scheduledTime.isBefore(DateTime.now())) {
          print('⏭️  Skipped (past): ${notification.title}');
          continue;
        }

        await _notificationService.scheduleOneTimeNotification(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          scheduledDate: notification.scheduledTime,
        );

        scheduled++;
        print('✅ Scheduled: ${notification.title}');
      }

      // 예약 완료 후 삭제
      await NotificationScheduler.clearStoredNotifications();

      print('✅ $scheduled/${notifications.length} notifications scheduled');
    } catch (e, stack) {
      print('❌ Error scheduling stored notifications: $e');
      print(stack);
    }
  }

  // 마지막 접속 시간 저장
  Future<void> updateLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_login', DateTime.now().toIso8601String());
    print('📅 Last login updated: ${DateTime.now()}');
  }

  // 예약된 알림 목록 출력 (디버깅용)
  Future<void> printPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    print('📋 Pending notifications: ${pending.length}');
    for (var notification in pending) {
      print('  - ID: ${notification.id}, Title: ${notification.title}');
    }
  }

  // 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }
}
