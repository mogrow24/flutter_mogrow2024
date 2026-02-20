import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../database/database.dart';

class NotificationData {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledTime;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime.toIso8601String(),
      };

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
    );
  }
}

class NotificationScheduler {
  static const String _key = 'pending_notifications';
  static const String _lastLoginKey = 'last_login';

  // 내일 알림 데이터 계산해서 저장
  static Future<void> calculateTomorrowNotifications() async {
    try {
      print('📊 Calculating tomorrow notifications...');

      final db = Database();
      final prefs = await SharedPreferences.getInstance();

      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowMidnight =
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0);

      List<NotificationData> notifications = [];

      // 1. 목표 조회
      final goalList = await db.goalDao.getAllGoals();

      for (var goal in goalList) {
        if (goal.dateDiv == "2") {
          // 디데이 체크
          if (_isSameDay(goal.endDate!, tomorrow)) {
            notifications.add(NotificationData(
              id: 5000 + (int.tryParse(goal.goalId.split("-")[1]) ?? 0),
              title: '오늘은 ${goal.title} 완료일!',
              body: '그동안 진행했던 프로젝트가 완료되었어요!',
              scheduledTime: tomorrowMidnight,
            ));
            print('✅ D-Day: ${goal.title}');
          }
        } else if (goal.dateDiv == "1") {
          // D+일 체크
          if (goal.startDate != null) {
            final daysElapsed = tomorrow.difference(goal.startDate!).inDays;
            // 5일마다
            if (daysElapsed > 0 && daysElapsed % 5 == 0) {
              notifications.add(NotificationData(
                id: 6000 + (int.tryParse(goal.goalId.split("-")[1]) ?? 0),
                title: '${goal.title} $daysElapsed일',
                body: '오늘은 ${goal.title}가 진행된지 $daysElapsed일째에요!',
                scheduledTime: tomorrowMidnight,
              ));
              print('✅ D+$daysElapsed: ${goal.title}');
            }
          }
        }
      }

      // 2. 미완료 할일 체크
      final cnt = await db.todoDao.getTodoNotCompleteByToday();
      if (cnt > 0) {
        notifications.add(NotificationData(
          id: 7000,
          title: '미완료 $cnt 건',
          body: '오늘의 할 일을 완료해 주세요.',
          scheduledTime:
              DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 18, 0),
        ));
        print('✅ No tasks notification');
      }

      // 3. 접속 체크 (마지막 접속 일수)
      final lastLoginStr = prefs.getString(_lastLoginKey);
      if (lastLoginStr != null) {
        final lastLogin = DateTime.parse(lastLoginStr);
        final daysNoLogin = DateTime.now().difference(lastLogin).inDays;

        if (daysNoLogin >= 3) {
          notifications.add(NotificationData(
            id: 12,
            title: '프로젝트가 중단 되었나요?',
            body: '지금 바로 접속해서 할 일을 작성해 보세요!',
            scheduledTime: tomorrowMidnight,
          ));
          print('   ✅ 3 days no login notification added');
        } else if (daysNoLogin >= 1) {
          notifications.add(NotificationData(
            id: 13,
            title: '오늘의 할 일은?',
            body: '오늘의 할 일은 무엇인가요? 지금 바로 적어 보세요!',
            scheduledTime:
                DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 8, 0),
          ));
          print('   ✅ 1 day no login notification added');
        }
      }

      // 3. SharedPreferences에 저장
      final jsonList = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_key, json.encode(jsonList));

      await db.close();

      print(
          '✅ ${notifications.length} notifications saved to SharedPreferences');
    } catch (e, stack) {
      print('❌ Error calculating notifications: $e');
      print(stack);
    }
  }

  // 저장된 알림 데이터 읽어서 실제 알림 예약
  static Future<List<NotificationData>?> getStoredNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_key);

      if (jsonStr == null) {
        return null;
      }

      final jsonList = json.decode(jsonStr) as List;
      return jsonList.map((j) => NotificationData.fromJson(j)).toList();
    } catch (e, stack) {
      print('❌ Error scheduling stored notifications: $e');
      print(stack);
    }
    return null;
  }

  // 저장된 알림 데이터 삭제
  static Future<void> clearStoredNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
