import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mogrow/database/todos.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    Todos,
  ],
)
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //       onCreate: (Migrator m) async {
  //         await m.createAll();
  //       },
  //       onUpgrade: (Migrator m, int from, int to) async {
  //         if (from < 2) {
  //           await m.addColumn(todos, todos.추가할컬럼명);
  //         }
  //       }
  //   );
  // }

  // @override
  // MigrationStrategy get migrationStrategy => MigrationStrategy(
  //       onUpgrade: (Migrator m, int from, int to) async {
  //         if (from == 1 && to >= 2) {
  //           await m.addColumn(todos, todos.newColumn); // 새로운 컬럼 추가
  //         }
  //         if (from == 2 && to >= 3) {
  //           await m.addColumn(todos, todos.anotherNewColumn); // 또 다른 컬럼 추가
  //         }
  //         // ... 추가적인 마이그레이션 로직
  //       },
  //     );

  // DAO 인스턴스 생성
  TodoDao get todoDao => TodoDao(this);
}
/* 
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mogrow/screens/home/model/todos.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Todos])
class Mydatabase extends _$Mydatabase {
  Mydatabase() : super(_openDb());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openDb() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

 */