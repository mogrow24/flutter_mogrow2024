import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';

class AchieveListProvider extends ChangeNotifier {
  final Database database;
  DateTime? installDate;

  List<Record> _recordList = [];
  List<Todo> _todoList = [];

  // 생성자 함수
  AchieveListProvider(this.database);

  List<Record> get recordList => _recordList;
  List<Todo> get todoList => _todoList;

  // 설치날짜 db 저장
  Future<void> insertInstallDate() async {
    await database.installInfoDao.initializeInstallDate();
  }

  Future<void> getInstallDate() async {
    installDate = await database.installInfoDao.getInstallDate();
  }

  // 검색
  Future<void> searchByGoalId(String searchWord, String goalId) async {
    // goalId를 받아서 todoList랑 RecordList를 전부 조회.
    // 조회한 List에서 검색어를 필터링 후 List에 저장

    final tempTodoList = await database.todoDao.getTodosByGoalId(goalId);
    final tempRecordList =
        await database.recordDao.getRecordListByGoalId(goalId);

    _todoList = tempTodoList
        .where((item) =>
            item.title.toLowerCase().contains(searchWord.toLowerCase()))
        .toList();
    _recordList = tempRecordList
        .where((item) =>
            item.surveyComment.toLowerCase().contains(searchWord.toLowerCase()))
        .toList();
  }

  Future<List<Todo>> todoListBySearchWord(
      String searchWord, String goalId) async {
    final tempTodoList = await database.todoDao.getTodosByGoalId(goalId);

    // return tempTodoList
    //     .where((item) =>
    //         item.title.toLowerCase().contains(searchWord.toLowerCase()))
    //     .toList();

    return await database.todoDao.getTodosByGoalId(goalId);
  }

  Future<List<Record>> recordListBySearchWord(
      String searchWord, String goalId) async {
    final tempRecordList =
        await database.recordDao.getRecordListByGoalId(goalId);

    // return tempRecordList
    //     .where((item) =>
    //         item.surveyComment.toLowerCase().contains(searchWord.toLowerCase()))
    //     .toList();
    return await database.recordDao.getRecordListByGoalId(goalId);
  }
}
