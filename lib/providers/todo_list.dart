import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoListProvider extends ChangeNotifier {
  List<Todo> todoList = [];
  List<Todo> repeatList = [];
  Todo? _todo;
  final Database database;
  Map<DateTime, bool> dateHasDataMap = {};
  Map<DateTime, List<Todo>> dateTodoList = {};
  Todo? _previousTodo;
  List<Goal> goalList = [];

  // 명언
  String _message = '';
  String _author = '';

  String get message => _message;
  String get author => _author;

  // cnt
  int allTodoCnt = 0;

  late int year;
  late int month;

  // 생성자에서 초기화 (fetchTodos 호출 전에 항상 값 보장)
  TodoListProvider(this.database) {
    final now = DateTime.now();
    year = now.year;
    month = now.month;
  }

  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  CalendarFormat get calendarFormat => _calendarFormat;

  // 로딩
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Todo? get todo => _todo;
  Todo? get previousTodo => _previousTodo;

  // Custom ID 생성 함수 호출
  Future<String> getNextCustomId(DateTime selectedDay) async {
    return await database.todoDao.getNextCustomId(selectedDay);
  }

  Future<String> getRepeatGroupId(DateTime selectedDay) async {
    return await database.todoDao.getRepeatGroupId(selectedDay);
  }

  Future<void> addTodo(Todo todo) async {
    // print("데이터 삽입");
    // print(todo);

    // 데이터베이스에 삽입
    await database.todoDao.insertTodo(
      TodosCompanion(
        id: Value(todo.id),
        goalId: Value(todo.goalId),
        title: Value(todo.title),
        gemstone: Value(todo.gemstone),
        goalTitle: Value(todo.goalTitle),
        repeat: Value(todo.repeat),
        repeatCode: Value(todo.repeatCode),
        repeatGroupId: Value(todo.repeatGroupId),
        repeatStartDate: Value(todo.repeatStartDate),
        repeatEndDate: Value(todo.repeatEndDate),
        status: Value(todo.status),
        isCompleted: Value(todo.isCompleted),
        isContinue: Value(todo.isContinue),
        date: Value(todo.date),
      ),
    );

    // 삽입 후 데이터를 다시 가져오기
    await fetchTodos();
  }

  // 조회(일반일정)
  Future<void> fetchTodos() async {
    // print("할일 조회!!!");
    goalList = await database.goalDao.getAllGoals();

    final DateTime baseDate = DateTime(year, month);

    // 1.5년 치 데이터 조회
    final DateTime startDate = DateTime(baseDate.year, baseDate.month - 6);
    final DateTime endDate = DateTime(baseDate.year, baseDate.month + 12);

    // 반복 일정이 있는 일정들을 먼저 가공(+반복제외도)
    final fetchedRepeatTodos = await getTodosByRepeat(startDate, endDate);

    // 일반일정만 조회
    final fetchedTodos =
        await database.todoDao.getTodosByDate(startDate, endDate);

    // 반복없는 일정 중에 반복그룹이 있으면 반복에서 반복없음으로 변경 된거
    // 해당 반복 이름에 (반복) -> 반복없음 으로 해줘야함.
    for (final todo in fetchedTodos) {
      if (todo.repeatGroupId != null) {
        final previousTodo =
            await database.todoDao.getRepeat(todo.repeatGroupId!, todo.date!);

        if (previousTodo != null) {
          final idx = fetchedTodos.indexOf(todo);
          final newRepeat = '${previousTodo.repeat} -> ${todo.repeat}';

          fetchedTodos[idx] = todo.copyWith(
            repeat: Value(newRepeat),
          );
        }
      }
    }

    // 가공된 반복일정 + 일반일정
    todoList = [...fetchedRepeatTodos, ...fetchedTodos];

    // print("==== 총 할일 ====");
    // for (var ele in todoList) {
    //   print(ele);
    // }

    // print("반복없는 일반 일정!!!!!!!");
    // print(fetchedTodos);

    // 할일 총 갯수
    allTodoCnt = todoList.length;

    // 리스트를 Map<DateTime, List<Todo>> 형태로 변환
    dateTodoList = groupTodosByDate(todoList);

    // Map<DateTime, bool> 형태로 변환 -> 캘린더의 marker 표시를 위해
    _updateDateHasDataMap(dateTodoList);

    notifyListeners();
  }

  // 조회(반복일정)
  Future<List<Todo>> getTodosByRepeat(DateTime start, DateTime end) async {
    final repeatedTodos = await database.todoDao.getTodosByRepeat();
    final excludes = await database.repeatExcludeDao.getAllExcludes();

    final repeatedList = <Todo>[];

    for (final todo in repeatedTodos) {
      // 반복 있는 일정들을 1.5년치 복사
      final dates = getRepeatDates(todo, start, end, excludes);

      // 결과가 없으면 해당 todo 삭제 -> 반복을 전부 지웠을 때 남아있는 데이터 정리
      if (dates.isEmpty) {
        await database.todoDao.deleteTodo(todo.id);
        await database.repeatExcludeDao.deleteRepeatExcludeById(todo.id);
        continue; // 삭제 후 건너 뜀
      }

      // todo의 date => current
      // 이 current에만 repeat 네임을 수정
      final current = todo.date!;
      // 반복설정된 그룹 중에서 시작 날짜의 할일과 종료날짜가 같은 할일
      final tempTodo =
          await database.todoDao.getRepeat(todo.repeatGroupId!, current);

      // print("현재(시작)날짜 $current !!!!!!!!!!!!!!!!");
      // print("이전 할일 존재 여부 $tempTodo !!!!!!!!!!!!!!");

      for (final date in dates) {
        // 반복되는 일정 중 맨 처음 시작되는 날에는 반복이 바뀐 표시
        if (date == current && tempTodo != null) {
          final newRepeat = '${tempTodo.repeat} -> ${todo.repeat}';

          repeatedList.add(todo.copyWith(
            date: Value(date),
            repeat: Value(newRepeat),
          ));
        } else {
          repeatedList.add(todo.copyWith(
            date: Value(date),
          ));
        }
      }
    }

    return repeatedList;
  }

  // 반복 제외된 일정을 빼고 선택 날짜의 (1.5년치 데이터) 만큼 반복에 따라 저장
  List<DateTime> getRepeatDates(
      Todo todo, DateTime start, DateTime end, List<RepeatExclude> excludes) {
    final List<DateTime> result = [];

    // print(excludes);

    final excludeDates = excludes
        .where((t) => t.todoId == todo.id)
        .map((e) => DateTime(
              e.excludedDate.year,
              e.excludedDate.month,
              e.excludedDate.day,
            ))
        .toSet();

    // print("반복에서 제외된 일정!!!!!!!");
    // print(excludeDates);

    DateTime current = todo.date!;
    final DateTime? repeatEndDate = todo.repeatEndDate;
    final int originalDay = todo.date!.day; // 원본 날짜 저장

    // 종료 조건: end 범위 초과하거나, repeatEnddate 초과하면 종료
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (repeatEndDate != null &&
          (current.isAfter(repeatEndDate) ||
              current.isAtSameMomentAs(repeatEndDate))) {
        break;
      }

      // start 이후부터 저장
      if (current.isAfter(start.subtract(Duration(days: 1)))) {
        final key = DateTime(current.year, current.month, current.day);
        if (!excludeDates.contains(key)) {
          result.add(current);
        }
      }

      switch (todo.repeatCode) {
        case "1": // 매일
          current = current.add(Duration(days: 1));
          break;
        case "2": // 평일
          do {
            current = current.add(Duration(days: 1));
          } while (current.weekday == DateTime.saturday ||
              current.weekday == DateTime.sunday);
          break;
        case "3": // 매주
          current = current.add(Duration(days: 7));
          break;
        case "4": // 격주
          current = current.add(Duration(days: 14));
          break;
        case "5": // 매월
          int nextMonth = current.month + 1;
          int nextYear = current.year;
          if (nextMonth > 12) {
            nextMonth = 1;
            nextYear++;
          }

          final lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
          final targetDay = originalDay > lastDayOfNextMonth
              ? lastDayOfNextMonth
              : originalDay;

          current = DateTime(nextYear, nextMonth, targetDay);
          break;
        case "6": // 매월 넷째주
          final nextMonth = DateTime(current.year, current.month + 1, 1);
          final weekday = current.weekday;
          int count = 0;
          DateTime temp = nextMonth;

          while (temp.month == nextMonth.month) {
            if (temp.weekday == weekday) {
              count++;
              if (count == 4) break;
            }
            temp = temp.add(Duration(days: 1));
          }

          current = temp;
          break;
        case "7": // 매월 마지막
          final nextMonth = DateTime(current.year, current.month + 1, 1);
          final lastDayOfNextMonth =
              DateTime(nextMonth.year, nextMonth.month + 1, 0);
          final weekday = current.weekday;

          current = lastDayOfNextMonth.subtract(
              Duration(days: (lastDayOfNextMonth.weekday - weekday + 7) % 7));
          break;
        case "8": // 매년
          current = DateTime(current.year + 1, current.month, current.day);
          break;
        default:
          break;
      }
    }

    return result;
  }

  // 수정 3가지 상황
  // 1. 반복설정 변화 없음
  // 1-1 반복 없음 -> 해당 일정 업데이트 처리
  // 1-2 반복 설정 -> 반복그룹의 일정 모두 업데이트 처리
  // 2. 이전반복없음/해당반복없음 에서 반복설정
  // 2-1. 반복 그룹이 없다면 해당 일정 업데이트 처리
  // 2-2. 반복 그룹이 있다면 반복그룹아이디 제외 업데이트 처리
  // 3. 반복설정에서 반복설정/반복없음
  // 4-1 선택 날짜에 (할일 종료날짜 업데이트/할일 새로 insert), 반복 그룹의 데이터 수정
  // 4-2 반복시작날짜만 그냥 업데이트 처리
  Future<void> updateTodo(
      String id, Map<String, dynamic> todo, String? type) async {
    // print("$id -> 투두리스트 수정!");
    // print(todo);
    // print('${todo["beforeRepeatCode"]} -> ${todo["repeatCode"]} 반복 수정!!!!!!!!');

    final repeatGroupId =
        await database.todoDao.getRepeatGroupId(todo['repeatEndDate']);

    DateTime endDay = todo['repeatEndDate'];
    DateTime oneDayAfter = endDay.add(Duration(days: 1));
    DateTime oneDayBefore = endDay.subtract(Duration(days: 1));

    // 반복 설정 수정이 없다면
    if (todo["beforeRepeatCode"] == todo["repeatCode"]) {
      final updateTodo = TodosCompanion(
        goalId: Value(todo['goalId']),
        title: Value(todo['title']),
        goalTitle: Value(todo['goalTitle']),
        gemstone: Value(todo['gemstone']),
        updateDate: Value(todo['updateDate']),
      );

      if (todo["repeatCode"] == "0") {
        // 반복 없음일 때
        await database.todoDao.updateTodoById(id, updateTodo);
      } else {
        // 반복 그룹에 해당되는 데이터 모두 수정
        await database.todoDao
            .updateTodoByRepeatGroup(todo["repeatGroupId"], updateTodo);
      }
    } else if (todo["beforeRepeatCode"] == "0") {
      // 반복 없음인데 반복 그룹이 있는지 없는지 확인
      TodosCompanion updateTodo;
      if (todo["repeatGroupId"] != null) {
        updateTodo = TodosCompanion(
          goalId: Value(todo['goalId']),
          title: Value(todo['title']),
          goalTitle: Value(todo['goalTitle']),
          gemstone: Value(todo['gemstone']),
          repeat: Value(todo['repeat']),
          repeatCode: Value(todo['repeatCode']),
          repeatStartDate: Value(todo['repeatEndDate']),
          repeatEndDate: Value(null),
          updateDate: Value(todo['updateDate']),
        );
      } else {
        // 반복없음 -> 반복설정 시 해당 일정에 수정
        updateTodo = TodosCompanion(
          goalId: Value(todo['goalId']),
          title: Value(todo['title']),
          goalTitle: Value(todo['goalTitle']),
          gemstone: Value(todo['gemstone']),
          repeat: Value(todo['repeat']),
          repeatCode: Value(todo['repeatCode']),
          repeatStartDate: Value(todo['repeatEndDate']),
          repeatEndDate: Value(null),
          repeatGroupId: Value(repeatGroupId),
          updateDate: Value(todo['updateDate']),
        );
      }

      await database.todoDao.updateTodoById(id, updateTodo);
    } else {
      // 반복 설정이 수정되면 -> 새로 insert, 지금 반복되는 할일의 종료날짜 업데이트, 반복 그룹에 해당되는 데이터 모두 수정,

      // 반복이 시작되는 날짜와 선택된 날짜가 같다면 그냥 업데이트
      if (todo['repeatStartDate'] == todo['repeatEndDate']) {
        // print(
        //     '${todo['repeatStartDate']} 와 ${todo['repeatEndDate']} 같을 떄!!!!!!!!!!!');
        final updateTodo = TodosCompanion(
          goalId: Value(todo['goalId']),
          title: Value(todo['title']),
          goalTitle: Value(todo['goalTitle']),
          gemstone: Value(todo['gemstone']),
          repeat: Value(todo['repeat']),
          repeatCode: Value(todo['repeatCode']),
          repeatEndDate: Value(null),
          // repeatGroupId: todo["repeatCode"] == "0" ? Value(todo['repeatGroupId']) : Value(repeatGroupId),
          updateDate: Value(todo['updateDate']),
        );
        await database.todoDao.updateTodoById(id, updateTodo);
      } else {
        // print(
        //     '${todo['repeatStartDate']} 와 ${todo['repeatEndDate']} 다를 떄!!!!!!!!!!!');
        // 반복 그룹에 해당되는 데이터 모두 수정(반복 제외)
        final updateTodo1 = TodosCompanion(
          goalId: Value(todo['goalId']),
          title: Value(todo['title']),
          goalTitle: Value(todo['goalTitle']),
          gemstone: Value(todo['gemstone']),
          updateDate: Value(todo['updateDate']),
        );
        await database.todoDao
            .updateTodoByRepeatGroup(todo["repeatGroupId"], updateTodo1);

        // 종료 날짜
        final updateTodo2 = TodosCompanion(
          repeatEndDate: Value(todo['repeatEndDate']),
          updateDate: Value(todo['updateDate']),
        );
        await database.todoDao.updateTodoById(id, updateTodo2);

        // 현재날짜 이후에 있는 반복 그룹 모두 삭제
        await database.todoDao
            .deleteByRepeatGroupId(todo["repeatGroupId"], endDay);

        // 데이터베이스에 새로 삽입
        final customId =
            await database.todoDao.getNextCustomId(todo['repeatEndDate']);

        await database.todoDao.insertTodo(
          TodosCompanion(
            id: Value(customId),
            goalId: Value(todo['goalId']),
            title: Value(todo['title']),
            goalTitle: Value(todo['goalTitle']),
            gemstone: Value(todo['gemstone']),
            repeat: Value(todo['repeat']),
            repeatCode: Value(todo['repeatCode']),
            repeatStartDate: Value(todo['repeatEndDate']),
            repeatEndDate: Value(null),
            repeatGroupId: Value(todo['repeatGroupId']),
            status: Value(false),
            isCompleted: Value(false),
            isContinue: Value(false),
            date: Value(todo['repeatEndDate']),
          ),
        );
      }
    }
/*
    if (todo["beforeRepeatCode"] == "0") {
      // 반복없음 -> 반복설정 시 해당 일정에 수정
      final updateTodo = TodosCompanion(
        goalId: Value(todo['goalId']),
        title: Value(todo['title']),
        goalTitle: Value(todo['goalTitle']),
        gemstone: Value(todo['gemstone']),
        repeat: Value(todo['repeat']),
        repeatCode: Value(todo['repeatCode']),
        repeatEndDate: Value(null),
        repeatGroupId: Value(repeatGroupId),
        updateDate: Value(todo['updateDate']),
      );
      await database.todoDao.updateTodoById(id, updateTodo);
    } else {
      // 선택한 일정, 이후 모든 일정 수정에 대한 처리
      if (type == "update") {
        print("해당 일자만 수정!!!!!!!!!!!!");

        // 일정 제외 테이블에 해당 일정을 추가
        await database.repeatExcludeDao
            .insertRepeatExclude(RepeatExcludesCompanion(
          todoId: Value(id),
          excludedDate: Value(todo['repeatEndDate']),
        ));

        // 기존 일정에 선택된 날짜를 종료 날짜로 수정
        final updateTodo = TodosCompanion(
          repeatEndDate: Value(todo['repeatEndDate']),
          updateDate: Value(todo['updateDate']),
        );
        await database.todoDao.updateTodoById(id, updateTodo);

        // 데이터베이스에 새로 삽입
        final customId =
            await database.todoDao.getNextCustomId(todo['repeatEndDate']);

        await database.todoDao.insertTodo(
          TodosCompanion(
            id: Value(customId),
            goalId: Value(todo['goalId']),
            title: Value(todo['title']),
            goalTitle: Value(todo['goalTitle']),
            gemstone: Value(todo['gemstone']),
            repeat: Value(todo['repeat']),
            repeatCode: Value(todo['repeatCode']),
            repeatEndDate: Value(null),
            repeatGroupId: Value(todo['repeatGroupId']),
            status: Value(false),
            isCompleted: Value(false),
            isContinue: Value(false),
            date: Value(todo['repeatEndDate']),
          ),
        );

        // if (todo["repeatCode"] == "0") {
        //   // 수정 시 "반복 없음" 일 경우
        //   await database.todoDao.insertTodo(
        //     TodosCompanion(
        //       id: Value(customId),
        //       goalId: Value(todo['goalId']),
        //       title: Value(todo['title']),
        //       goalTitle: Value(todo['goalTitle']),
        //       gemstone: Value(todo['gemstone']),
        //       repeat: Value(todo['repeat']),
        //       repeatCode: Value(todo['repeatCode']),
        //       repeatEndDate: Value(null),
        //       repeatGroupId: Value(todo['repeatGroupId']),
        //       status: Value(false),
        //       isCompleted: Value(false),
        //       isContinue: Value(false),
        //       date: Value(todo['repeatEndDate']),
        //     ),
        //   );
        // } else {

        // }
      } else if (type == "repeatAll") {
        // 이후 모든 일정 수정 -> 기존 일정에 종료날짜 수정
        print("이후 모든 일정 수정!!!!!!!!!!!!!!!!");
/*
        // 기존 할일에 repeat 종료 날짜를 추가
        final updateTodo = TodosCompanion(
          repeatEndDate: Value(todo['repeatEndDate']),
          updateDate: Value(todo['updateDate']),
        );
        await database.todoDao.updateTodoById(id, updateTodo);

        // 데이터베이스에 새로 삽입
        final customId =
            await database.todoDao.getNextCustomId(todo['repeatEndDate']);
        await database.todoDao.insertTodo(
          TodosCompanion(
            id: Value(customId),
            goalId: Value(todo['goalId']),
            title: Value(todo['title']),
            goalTitle: Value(todo['goalTitle']),
            gemstone: Value(todo['gemstone']),
            repeat: Value(todo['repeat']),
            repeatCode: Value(todo['repeatCode']),
            repeatEndDate: Value(null),
            repeatGroupId: Value(todo['repeatGroupId']),
            status: Value(false),
            isCompleted: Value(false),
            isContinue: Value(false),
            date: Value(todo['repeatEndDate']),
          ),
        );
        */
      }
    }
*/
    await fetchTodos();
  }

  // 투두리스트에서 목표를 변경 했을 때
  Future<void> updateTodoGoal(
      Todo todo, DateTime selectedDay, Goal goal) async {
    final updateTodo;

    // print("${todo.id} -> 투두리스트 수정!!!!!!!");
    updateTodo = TodosCompanion(
      goalId: Value(goal.goalId),
      goalTitle: Value(goal.title),
      gemstone: Value(goal.gemstone),
      updateDate: Value(DateTime.now()),
    );

    try {
      if (todo.repeatGroupId != null) {
        await database.todoDao
            .updateTodoByRepeatGroup(todo.repeatGroupId!, updateTodo);
      } else {
        await database.todoDao.updateTodoById(todo.id, updateTodo);
      }

      await fetchTodos();
    } finally {
      setLoading(false);
    }

    // await Future.delayed(Duration(milliseconds: 400));
  }

  /// 반복 일정인 경우: 해당 날만 미루기(제외 + 내일 행 추가).
  /// 개별 행(완료/진행중으로 만든 행)이면 그 행만 날짜 변경.
  Future<void> updateTodoTomorrow(Todo todo, DateTime currentDate) async {
    final tomorrowDate = currentDate.add(Duration(days: 1));
    final id = todo.id;

    /* 기존 코드 주석 처리 */
    // final updateTodo = TodosCompanion(
    //   date: Value(tomorrowDate),
    //   updateDate: Value(DateTime.now()),
    // );
    // await database.todoDao.updateTodoById(id, updateTodo);

    /* 2026.02.11 반복 일절에 대한 코드 개선 */
    // 반복 없음 -> 해당 행만 내일로

    if (todo.repeatGroupId == null) {
      await database.todoDao.updateTodoById(
        id,
        TodosCompanion(
          date: Value(tomorrowDate),
          updateDate: Value(DateTime.now()),
        ),
      );
      await fetchTodos();
      return;
    }

    // 반복 일정: 이 행이 "개별 저장된 행"(instance)인지 확인
    // instance = repeatEndDate가 있어서 이 날짜 하나만 나타나는 행
    final isInstanceRow = todo.repeatEndDate != null &&
        _isSameDay(
            todo.repeatEndDate!, currentDate.add(const Duration(days: 1)));

    if (isInstanceRow) {
      // 개별 행만 내일로 이동
      await database.todoDao.updateTodoById(
        id,
        TodosCompanion(
          date: Value(tomorrowDate),
          repeatEndDate: Value(tomorrowDate.add(const Duration(days: 1))),
          updateDate: Value(DateTime.now()),
        ),
      );
    } else {
      // 시드(템플릿) 쪽에서 나온 occurrence → 해당 날만 미루기
      // 1) 이 날짜는 반복에서 제외
      await database.repeatExcludeDao.insertRepeatExclude(
        RepeatExcludesCompanion(
          todoId: Value(id),
          repeatGroupId: Value(todo.repeatGroupId!),
          excludedDate: Value(currentDate),
        ),
      );
      // 2) 내일 날짜로 새 행 한 건만 추가 (repeatEndDate로 하루만 표시)
      final customId = await database.todoDao.getNextCustomId(tomorrowDate);
      await database.todoDao.insertTodo(
        TodosCompanion(
          id: Value(customId),
          goalId: Value(todo.goalId),
          title: Value(todo.title),
          goalTitle: Value(todo.goalTitle),
          gemstone: Value(todo.gemstone),
          repeat: Value(todo.repeat),
          repeatCode: Value(todo.repeatCode),
          repeatStartDate: Value(tomorrowDate),
          repeatEndDate: Value(tomorrowDate.add(const Duration(days: 1))),
          repeatGroupId: Value(todo.repeatGroupId),
          status: Value(false),
          isCompleted: Value(false),
          isContinue: Value(false),
          date: Value(tomorrowDate),
        ),
      );
    }

    await fetchTodos();
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // 할일 완료 시 -> 데이터 추가, 반복 그룹,
  Future<void> updateIsCompleted(
      Todo todo, DateTime selectedDay, bool isCompleted) async {
    // print("할일 완료!!!!!");
    TodosCompanion updateTodo;

    // 반복없음 -> 해당 일정의 상태값 수정
    if (todo.repeatGroupId == null) {
      updateTodo = TodosCompanion(
        isCompleted: Value(isCompleted),
        isContinue: Value(!isCompleted),
        status: Value(false),
        updateDate: Value(DateTime.now()),
      );
      await database.todoDao.updateTodoById(todo.id, updateTodo);
    } else {
      // 반복설정
      // 1. 기존 일정의 반복 제외
      // 2. 해당 일자에 똑같은 일정으로 insert
      // 3. 완료 <-> 진행중 상태를 변경해야 하는데 둘중에 하나라도 true 가 있으면 위에 상황 진행 안하고, 그냥 업데이트

      if (todo.isCompleted || todo.isContinue) {
        // print("현재 완료/진행중 상태!!!!!!!!!");
        updateTodo = TodosCompanion(
          isCompleted: Value(isCompleted),
          isContinue: Value(!isCompleted),
          status: Value(false),
          updateDate: Value(DateTime.now()),
        );
        await database.todoDao.updateTodoById(todo.id, updateTodo);
      } else {
        // print("완료 false -> true !!!!!!!!!");
        // 데이터가 없으면 새로 등록 및 반복 제외 테이블에 등록
        await database.repeatExcludeDao
            .insertRepeatExclude(RepeatExcludesCompanion(
          todoId: Value(todo.id),
          repeatGroupId: Value(todo.repeatGroupId!),
          excludedDate: Value(selectedDay),
        ));

        // 데이터베이스에 새로 삽입
        final customId = await database.todoDao.getNextCustomId(selectedDay);

        await database.todoDao.insertTodo(TodosCompanion(
          id: Value(customId),
          goalId: Value(todo.goalId),
          title: Value(todo.title),
          goalTitle: Value(todo.goalTitle),
          gemstone: Value(todo.gemstone),
          repeat: Value(todo.repeat),
          repeatCode: Value(todo.repeatCode),
          repeatEndDate: Value(selectedDay.add(Duration(days: 1))),
          repeatGroupId: Value(todo.repeatGroupId),
          status: Value(false),
          isCompleted: Value(isCompleted),
          isContinue: Value(!isCompleted),
          date: Value(selectedDay),
        ));
      }
    }

    await fetchTodos();
  }

  Future<void> updateIsContinue(
      Todo todo, DateTime selectedDay, bool isContinue) async {
    // print("할일 진행중!!!!!");
    TodosCompanion updateTodo;

    // 반복없음 -> 해당 일정의 상태값 수정
    if (todo.repeatGroupId == null) {
      updateTodo = TodosCompanion(
        isCompleted: Value(!isContinue),
        isContinue: Value(isContinue),
        status: Value(false),
        updateDate: Value(DateTime.now()),
      );
      await database.todoDao.updateTodoById(todo.id, updateTodo);
    } else {
      // 반복설정
      // 1. 기존 일정의 반복 제외
      // 2. 해당 일자에 똑같은 일정으로 insert
      // 3. 완료 <-> 진행중 상태를 변경해야 하는데 둘중에 하나라도 true 가 있으면 위에 상황 진행 안하고, 그냥 업데이트

      if (todo.isCompleted || todo.isContinue) {
        // print("현재 완료/진행중 상태!!!!!!!!!");
        updateTodo = TodosCompanion(
          isCompleted: Value(!isContinue),
          isContinue: Value(isContinue),
          status: Value(false),
          updateDate: Value(DateTime.now()),
        );
        await database.todoDao.updateTodoById(todo.id, updateTodo);
      } else {
        // print("진행중 false -> true !!!!!!!!!");
        // 데이터가 없으면 새로 등록 및 반복 제외 테이블에 등록
        await database.repeatExcludeDao
            .insertRepeatExclude(RepeatExcludesCompanion(
          todoId: Value(todo.id),
          repeatGroupId: Value(todo.repeatGroupId!),
          excludedDate: Value(selectedDay),
        ));

        // 데이터베이스에 새로 삽입
        final customId = await database.todoDao.getNextCustomId(selectedDay);

        await database.todoDao.insertTodo(TodosCompanion(
          id: Value(customId),
          goalId: Value(todo.goalId),
          title: Value(todo.title),
          goalTitle: Value(todo.goalTitle),
          gemstone: Value(todo.gemstone),
          repeat: Value(todo.repeat),
          repeatCode: Value(todo.repeatCode),
          repeatEndDate: Value(selectedDay.add(Duration(days: 1))),
          repeatGroupId: Value(todo.repeatGroupId),
          status: Value(false),
          isCompleted: Value(!isContinue),
          isContinue: Value(isContinue),
          date: Value(selectedDay),
        ));
      }
    }

    await fetchTodos();
  }

  // 취소 버튼 시
  /* 2026.02.11 반복 일정 관련 코드 개선 */
  Future<void> cancelTodo(Todo todo, DateTime selectedDay) async {
    // 반복없음 + 반복 그룹 없음일 때: 상태만 초기화
    if (todo.repeatCode == "0" && todo.repeatGroupId == null) {
      await database.todoDao.updateTodoById(
          todo.id,
          TodosCompanion(
            isCompleted: Value(false),
            isContinue: Value(false),
            status: Value(false),
            updateDate: Value(DateTime.now()),
          ));
      await fetchTodos();
      return;
    }

    // 반복 일정이어도(개별 행이든 시드든) 취소 = 완료/진행중 상태만 false로 되돌림
    await database.todoDao.updateTodoById(
        todo.id,
        TodosCompanion(
          isCompleted: Value(false),
          isContinue: Value(false),
          status: Value(false),
          updateDate: Value(DateTime.now()),
        ));

    await fetchTodos();
  }

  // 해당 날짜에 데이터가 있는지
  void _updateDateHasDataMap(Map<DateTime, List<Todo>> todosByDate) {
    dateHasDataMap = {
      for (var date in todosByDate.keys)
        date: todosByDate[date]?.isNotEmpty ?? false,
    };
  }

  // Todo 목록을 DateTime에 따라 그룹화
  Map<DateTime, List<Todo>> groupTodosByDate(List<Todo> todos) {
    Map<DateTime, List<Todo>> groupedTodos = {};
    for (var todo in todos) {
      if (todo.date == null) continue;

      final date = DateTime(todo.date!.year, todo.date!.month, todo.date!.day);

      // 목표 날짜에 따라 필터링

      final goal = goalList.firstWhere(
        (goal) => goal.goalId == todo.goalId,
        orElse: () => Goal(
            goalId: "1",
            title: "",
            gemstone: "",
            isCompleted: false,
            status: false),
      );
      if (goal.goalId == "1") continue;

      final start = goal.startDate != null
          ? DateTime(
              goal.startDate!.year, goal.startDate!.month, goal.startDate!.day)
          : date;

      final end = goal.endDate != null
          ? DateTime(goal.endDate!.year, goal.endDate!.month, goal.endDate!.day)
          : null;

      // 날짜가 범위 내에 있는지
      final isRange = end == null
          ? !date.isBefore(start)
          : !date.isBefore(start) && !date.isAfter(end);

      if (!isRange) continue;

      // 유효한 경우 날짜 기준으로 그룹화
      if (!groupedTodos.containsKey(date)) {
        groupedTodos[date] = [];
      }
      groupedTodos[date]!.add(todo);
    }
    return groupedTodos;
  }

  Future<void> deleteTodos(String id) async {
    // DB 삭제
    await database.todoDao.deleteTodo(id);

    // todoList에서도 해당 항목 삭제
    todoList.removeWhere((todo) => todo.id == id);

    // 그룹화된 데이터 업데이트
    // dateTodoList = groupTodosByDate(todoList);
    // _updateDateHasDataMap(dateTodoList);

    await fetchTodos();
    notifyListeners();
  }

  // 반복 일정 삭제(해당 할일)
  /*
  선택 된 반복 일정 삭제
  2026.02.11 해당 기능 사용 안함 (삭제 시 모든 반복 일정 삭제)
   */
  /*
  Future<void> deleteRepeatSelect(Todo todo, DateTime selectedDay) async {
    // excludes table insert
    final insertRepeatExclude = RepeatExcludesCompanion(
      todoId: Value(todo.id),
      excludedDate: Value(selectedDay),
    );

    await database.repeatExcludeDao.insertRepeatExclude(insertRepeatExclude);

    await fetchTodos();
  }
  */

  // 반복 일정 삭제(이후 모든 할일)
  Future<void> deleteRepeatAll(Todo todo, DateTime selectedDay) async {
    // print("이후 모든 일정 삭제!!!!!!!");
    final updateTodo = TodosCompanion(
      repeatEndDate: Value(selectedDay),
    );

    // 1. 선택 날짜 이후 반복 설정 되어 있는 그룹들을 전부 삭제
    await database.todoDao
        .deleteByRepeatGroupId(todo.repeatGroupId!, selectedDay);

    // 2. 그 이외의 그룹은 반복 종료 날짜를 update
    await database.todoDao.updateTodoByRepeatGroupId(
        todo.repeatGroupId!, updateTodo, selectedDay);

    await fetchTodos();
  }

  int getListCntByGoalId(String id, DateTime selectedDay) {
    final todoList = dateTodoList[selectedDay] ?? [];
    return todoList.where((item) => item.goalId == id).length;
  }

// 목표 아이디 받아 완료 여부 카운트
  int getCompleltedCnt(String id, DateTime selectedDay) {
    final todoList = dateTodoList[selectedDay] ?? [];
    return todoList
        .where((item) => item.goalId == id && item.isCompleted)
        .length;
  }

  List<Todo> getListByGoalId(String id, DateTime selectedDay) {
    final todoList = dateTodoList[selectedDay] ?? [];
    return todoList.where((item) => item.goalId == id).toList();
  }

  List<Todo> getListByGoalIdAll(String id) {
    return todoList.where((item) => item.goalId == id).toList();
  }

  Future<void> getTodoById(String id) async {
    _todo = await database.todoDao.getTodoById(id);
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 캘린더의 선택 날짜
  void setSeletedDay(DateTime date) {
    _selectedDay = date;
    _focusedDay = date;
    notifyListeners();
  }

  // 캘린더 날짜 선택
  void setFocusedDay(DateTime date) {
    _focusedDay = date;
    notifyListeners();
  }

  // 캘린더 형태 (월, 주)
  void setCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  // 명언 저장
  void updateMessage(String newMessage, String newAuthor) {
    _message = newMessage;
    _author = newAuthor;
  }
}
