import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';

class GoalListProvider extends ChangeNotifier {
  List<Goal> goalList = [];
  final Database database;
  Map<DateTime, bool> dateHasDataMap = {};
  Goal? _goal;

  // cnt
  int completedCnt = 0;

  /// 스플래시 등에서 앱 초기화 완료 대기용
  late final Future<void> ready;

  // 생성자 함수
  GoalListProvider(this.database) {
    // print("GoalProvider 생성됨!!!!!!!!!!");
    ready = _init();
  }

  Future<void> _init() async {
    await initializeDate(); // "기타" 목표 초기 세팅
    await fetchGoals();
  }

  Goal? get goal => _goal;

  // Custom ID 생성 함수 호출
  Future<String> getNextCustomId() async {
    return await database.goalDao.getNextCustomId();
  }

  Future<void> initializeDate() async {
    // print("'기타' 목표 초기 세팅");
    await database.goalDao.initializeDate();
    // notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    // print("데이터 삽입");
    // print(goal);

    // 데이터베이스에 삽입
    await database.goalDao.insertGoal(
      GoalsCompanion(
        goalId: Value(goal.goalId),
        title: Value(goal.title),
        subTitle: Value(goal.subTitle),
        gemstone: Value(goal.gemstone),
        dateDiv: Value(goal.dateDiv),
        startDate: Value(goal.startDate),
        endDate: Value(goal.endDate),
        desc: Value(goal.desc),
      ),
    );

    // notifyListeners();
    // 삽입 후 데이터를 다시 가져오기
    await fetchGoals();
  }

  Future<void> fetchGoals() async {
    goalList = await database.goalDao.getAllGoals();
    // print("목표리스트 호출!!!!");
    // print(goalList);

    // 목표 달성 완료 갯수
    completedCnt = await database.goalDao.getCompletedCount();

    notifyListeners();
  }

  // 목표 삭제
  // 목표(1. 목표, 2. 기록, 3. 할일)
  Future<void> deleteGoals(String id) async {
    // DB 삭제
    await database.goalDao.deleteGoal(id);

    await fetchGoals();
  }

  // 아이디 -> 목표 가져오기
  Future<void> getGoalById(String id) async {
    _goal = await database.goalDao.getGoalById(id);
    notifyListeners();
  }

  // 목표 날짜 범위로 필터링
  List<Todo> getFilteredTodoList(List<Todo> list) {
    return list.where((todo) {
      final goal = goalList.firstWhere(
        (goal) => goal.goalId == todo.goalId,
        orElse: () => Goal(
            goalId: "1",
            title: "",
            gemstone: "",
            isCompleted: false,
            status: false),
      );
      if (goal.goalId == "1") return false;

      final start = goal.startDate!;
      final end = goal.endDate;

      if (end == null) {
        return todo.date!.isAtSameMomentAs(start) || todo.date!.isAfter(start);
      } else {
        return todo.date!.isAfter(start.subtract(Duration(days: 1))) &&
            todo.date!.isBefore(end.add(Duration(days: 1)));
      }
    }).toList();
  }

  // 목표 이유 업데이트
  Future<void> updateReason(String id, String reason) async {
    // DB update
    // print("목표 이유 업데이트!!");
    // print(reason);
    await database.goalDao.updateReason(id, reason);

    await fetchGoals();
  }

  Future<void> updateGoal(Goal goal) async {
    // print("목표 업데이트!!");

    // 데이터베이스에 삽입
    await database.goalDao.updateGoal(
      goal.goalId,
      GoalsCompanion(
        goalId: Value(goal.goalId),
        title: Value(goal.title),
        subTitle: Value(goal.subTitle),
        gemstone: Value(goal.gemstone),
        dateDiv: Value(goal.dateDiv),
        startDate: Value(goal.startDate),
        endDate: Value(goal.endDate),
        desc: Value(goal.desc),
      ),
    );

    // 삽입 후 데이터를 다시 가져오기
    await fetchGoals();
    await getGoalById(goal.goalId);
  }

  // 목표 상태 업데이트
  Future<void> updateCompleted(String id, bool status) async {
    // DB update
    await database.goalDao.updateCompleted(id, status);

    await fetchGoals();
  }
}
