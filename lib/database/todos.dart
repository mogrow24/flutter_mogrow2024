// home 관련 data
import 'package:drift/drift.dart';
import 'package:mogrow/database/database.dart';
// ignore: unused_import
import 'package:mogrow/database/goals.dart';

part 'todos.g.dart';

@DataClassName('Todo')
class Todos extends Table {
  TextColumn get id => text()(); // Todo 항목의 고유 식별자
  TextColumn get title => text()(); // Todo의 내용
  TextColumn get gemstone => text()(); // Todo와 관련된 gemstone
  TextColumn get goalTitle => text()();
  TextColumn get repeat => text().nullable()(); // 반복 일정
  TextColumn get repeatCode => text().nullable()(); // 반복 일정 code
  TextColumn get repeatGroupId => text().nullable()(); // 반복 group id
  DateTimeColumn get repeatStartDate => dateTime().nullable()(); // 반복 시작
  DateTimeColumn get repeatEndDate => dateTime().nullable()(); // 반복 end
  BoolColumn get status => boolean().withDefault(Constant(false))(); // 상태
  BoolColumn get isCompleted =>
      boolean().withDefault(Constant(false))(); // 완료 여부
  BoolColumn get isContinue =>
      boolean().withDefault(Constant(false))(); // 계속 여부
  DateTimeColumn get date => dateTime().nullable()(); // 관련 날짜
  DateTimeColumn get createDate =>
      dateTime().nullable().clientDefault(() => DateTime.now())(); // 현재시간 디폴트
  DateTimeColumn get updateDate => dateTime().nullable()();
  TextColumn get goalId => text().customConstraint(
      'REFERENCES goals(goal_id) ON DELETE CASCADE NOT NULL')(); // goal ID

  // 컬럼별 제약조건 설정
  @override
  List<String> get customConstraints => ['UNIQUE (id)'];
}

@DriftAccessor(tables: [Todos])
class TodoDao extends DatabaseAccessor<Database> with _$TodoDaoMixin {
  TodoDao(super.attachedDatabase);

  Future<List<Todo>> getAllTodos() => select(todos).get();
  Future<List<Todo>> getTodosByDate(DateTime startDate, DateTime endDate) =>
      (select(todos)
            ..where((t) =>
                t.date.isBetweenValues(startDate, endDate) &
                t.repeatCode.equals("0")))
          .get();
  Future<Todo?> getTodoByDate(String id, DateTime date) =>
      (select(todos)..where((t) => t.id.equals(id) & t.date.equals(date)))
          .getSingleOrNull();
  Future<List<Todo>> getTodosByRepeat() =>
      (select(todos)..where((t) => t.repeatCode.equals("0").not())).get();
  Future<int> insertTodo(TodosCompanion todo) => into(todos).insert(todo);
  Future<bool> updateTodo(Todo todo) => update(todos).replace(todo);
  Future<int> deleteTodo(String id) =>
      (delete(todos)..where((t) => t.id.equals(id))).go();
  Future<int> deleteByRepeatGroupId(String id, DateTime selectedDay) =>
      (delete(todos)
            ..where((t) =>
                t.repeatGroupId.equals(id) &
                t.date.isBiggerThanValue(selectedDay)))
          .go();
  Future<int> updateTodoById(String id, TodosCompanion todo) =>
      (update(todos)..where((t) => t.id.equals(id))).write(todo);
  Future<int> updateTodoByRepeatGroup(
          String repeatGroupId, TodosCompanion todo) =>
      (update(todos)..where((t) => t.repeatGroupId.equals(repeatGroupId)))
          .write(todo);
  Future<int> updateTodoByRepeatGroupId(
          String repeatGroupId, TodosCompanion todo, DateTime selectedDay) =>
      (update(todos)
            ..where((t) =>
                t.repeatGroupId.equals(repeatGroupId) &
                (t.repeatEndDate.isBiggerThanValue(selectedDay) |
                    t.repeatEndDate.isNull())))
          .write(todo);
  Future<Todo?> getTodoById(String id) =>
      (select(todos)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<Todo?> getRepeat(String id, DateTime date) => (select(todos)
        ..where(
            (t) => t.repeatEndDate.equals(date) & t.repeatGroupId.equals(id)))
      .getSingleOrNull();
  Future<Todo?> getEndRepeat(String id) => (select(todos)
        ..where((t) => t.repeatEndDate.isNull() & t.repeatGroupId.equals(id)))
      .getSingleOrNull();
  Future<List<Todo>> getTodosByGoalId(String id) =>
      (select(todos)..where((t) => t.goalId.equals(id))).get();
  Future<int> getTodoNotCompleteByToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final query = selectOnly(todos)
      ..addColumns([todos.id.count()])
      ..where(todos.isCompleted.equals(false))
      ..where(todos.date.isBetweenValues(start, end));

    final row = await query.getSingle();
    return row.read(todos.id.count()) ?? 0;
  }

  // (update(todos)
  //  ..where((t) => t.id.equals(id)))
  //.write(TodosCompanion(
  //  status: Value(status),
  //))

  // id 생성
  Future<String> getNextCustomId(DateTime selectedDay) async {
    final todayPrefix = int.parse(
        '${selectedDay.year}${selectedDay.month.toString().padLeft(2, '0')}${selectedDay.day.toString().padLeft(2, '0')}');

    // 현재 날짜와 같은 ID 중 최대값 조회
    final maxIdResults = await (select(todos)
          ..where((tbl) => tbl.id.like('%$todayPrefix%'))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]))
        .get();

    // 다음 ID 계산
    if (maxIdResults.isNotEmpty) {
      final maxId = maxIdResults.first;
      final newId =
          (int.parse(maxId.id.split("-")[1]) + 1).toString().padLeft(3, '0');
      return "TODO$todayPrefix-$newId";
    } else {
      return "TODO$todayPrefix-001";
    }
  }

  // repeat group id 생성
  Future<String> getRepeatGroupId(DateTime selectedDay) async {
    final todayPrefix = int.parse(
        '${selectedDay.year}${selectedDay.month.toString().padLeft(2, '0')}${selectedDay.day.toString().padLeft(2, '0')}');

    // 현재 날짜와 같은 ID 중 최대값 조회
    final maxIdResults = await (select(todos)
          ..where((tbl) => tbl.repeatGroupId.like('%$todayPrefix%'))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.repeatGroupId)]))
        .get();

    // 다음 ID 계산
    if (maxIdResults.isNotEmpty) {
      final maxId = maxIdResults.first;
      final newId = (int.parse(maxId.repeatGroupId!.split("-")[1]) + 1)
          .toString()
          .padLeft(3, '0');
      return "REPEAT$todayPrefix-$newId";
    } else {
      return "REPEAT$todayPrefix-001";
    }
  }
}

// class TodosDao extends DatabaseAccessor<Database> with _$TodosDaoMixin {
//   TodosDao(super.db);

//   Future<List<Todo>> findAll() async {
//     return select(todos).get();
//   }

//   Future<List<Todo>> findByTitle(String title) async {
//     return (select(todos)..where((t) => t.title.equals(title))).get();
//   }

//   Future<int> createTodo(TodosCompanion data) async {
//     return into(todos).insert(data);
//   }

//   Future<int> updateTodo(int id, TodosCompanion data) async {
//     return (update(todos)..where((t) => t.id.equals(id))).write(data);
//   }

//   Future<int> updateTitle(int id, String title) async {
//     return (update(todos)..where((t) => t.id.equals(id)))
//         .write(TodosCompanion(title: Value(title)));
//   }

//   Future<int> deleteAll() async {
//     return delete(todos).go();
//   }

//   Future<int> deleteTodoById(int id) async {
//     return (delete(todos)..where((t) => t.id.equals(id))).go();
//   }
// }
