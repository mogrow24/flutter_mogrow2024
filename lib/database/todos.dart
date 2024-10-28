// home 관련 data
import 'package:drift/drift.dart';
import 'package:mogrow/database/database.dart';

part 'todos.g.dart';

@DataClassName('Todo')
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()(); // Todo 항목의 고유 식별자
  TextColumn get title => text()(); // Todo의 내용
  TextColumn get gemstone => text().nullable()(); // Todo와 관련된 gemstone
  TextColumn get repeat => text().nullable()(); // 반복 일정
  BoolColumn get status => boolean().withDefault(Constant(false))(); // 상태
  BoolColumn get isCompleted =>
      boolean().withDefault(Constant(false))(); // 완료 여부
  BoolColumn get isContinue =>
      boolean().withDefault(Constant(false))(); // 계속 여부
  DateTimeColumn get date => dateTime().nullable()(); // 관련 날짜

  @override
  List<String> get customConstraints => ['UNIQUE (id)'];
}

@DriftAccessor(tables: [Todos])
class TodoDao extends DatabaseAccessor<Database> with _$TodoDaoMixin {
  TodoDao(super.attachedDatabase);

  Future<List<Todo>> getAllTodos() => select(todos).get();
  Future<int> insertTodo(TodosCompanion todo) => into(todos).insert(todo);
  Future<bool> updateTodo(Todo todo) => update(todos).replace(todo);
  Future<int> deleteTodo(int id) =>
      (delete(todos)..where((t) => t.id.equals(id))).go();
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
