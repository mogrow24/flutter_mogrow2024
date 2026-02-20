import 'package:drift/drift.dart';
import 'package:mogrow/database/database.dart';

part 'repeat_exclude.g.dart';

@DataClassName('RepeatExclude')
class RepeatExcludes extends Table {
  @override
  String get tableName => 'RepeatExcludes'; // PascalCase로 유지
  IntColumn get id => integer().autoIncrement()();
  TextColumn get todoId => text()();
  TextColumn get repeatGroupId => text()();
  DateTimeColumn get excludedDate => dateTime()();

  // 컬럼별 제약조건 설정
  @override
  List<String> get customConstraints => ['UNIQUE (id)'];
}

@DriftAccessor(tables: [RepeatExcludes])
class RepeatExcludeDao extends DatabaseAccessor<Database>
    with _$RepeatExcludeDaoMixin {
  RepeatExcludeDao(super.attachedDatabase);

  Future<List<RepeatExclude>> getAllExcludes() => select(repeatExcludes).get();
  Future<RepeatExclude?> getExcludesByDate(String id, DateTime date) =>
      (select(repeatExcludes)
            ..where((t) =>
                t.repeatGroupId.equals(id) & t.excludedDate.equals(date)))
          .getSingleOrNull();
  Future<int> insertRepeatExclude(RepeatExcludesCompanion repeatExclude) =>
      into(repeatExcludes).insert(repeatExclude);
  Future<int> deleteRepeatExcludeById(String id) =>
      (delete(repeatExcludes)..where((t) => t.todoId.equals(id))).go();
  Future<int> deleteRepeatExcludeByDate(String id, DateTime selectedDay) =>
      (delete(repeatExcludes)
            ..where((t) =>
                t.repeatGroupId.equals(id) &
                t.excludedDate.equals(selectedDay)))
          .go();
}
