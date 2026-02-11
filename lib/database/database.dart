import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mogrow/database/goals.dart';
import 'package:mogrow/database/install_info.dart';
import 'package:mogrow/database/records.dart';
import 'package:mogrow/database/records_image.dart';
import 'package:mogrow/database/repeat_exclude.dart';
import 'package:mogrow/database/todos.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    // if (await file.exists()) {
    //   print("sql 파일 존재! 삭제하고 다시 생성합니다.");
    //   await file.delete();
    // }
    return NativeDatabase.createBackgroundConnection(file, setup: (database) {
      database.execute('PRAGMA foreign_keys = ON;');
    });
    // return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    InstallInfos,
    Todos,
    Goals,
    Records,
    RecordsImages,
    RepeatExcludes,
  ],
)
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  // onCreate: (Migrator m) async {
  //   await m.createAll();
  // },
  // onUpgrade: (Migrator m, int from, int to) async {
  //   if (from < 2) {
  //     await m.createTable(goals);
  //   }
  // }
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

  // 외래 키 확설화 확인
  Future<void> checkForeignKeys() async {
    final result = await customSelect('PRAGMA foreign_keys').get();
    print('foreign keys : ${result.first.data}!!!!');
  }

  // 테이블 스키마 확인
  Future<void> checkTableSchema(String tableName) async {
    final result = await customSelect('PRAGMA table_info($tableName)').get();
    print('$tableName 스키마: ');
    for (var row in result) {
      print(row.data);
    }

    // 외래 키 제약 조건 확인
    final fkResult =
        await customSelect('PRAGMA foreign_key_list($tableName)').get();
    print('$tableName 외래키: ');
    for (var row in fkResult) {
      print(row.data);
    }
  }

  // DAO 인스턴스 생성
  InstallInfoDao get installInfoDao => InstallInfoDao(this);
  TodoDao get todoDao => TodoDao(this);
  GoalDao get goalDao => GoalDao(this);
  RecordDao get recordDao => RecordDao(this);
  RecordsImageDao get recordImageDao => RecordsImageDao(this);
  RepeatExcludeDao get repeatExcludeDao => RepeatExcludeDao(this);
}
