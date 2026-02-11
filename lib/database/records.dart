import 'package:drift/drift.dart';
import 'package:mogrow/database/database.dart';
// ignore: unused_import
import 'package:mogrow/database/goals.dart';

part 'records.g.dart';

@DataClassName('Record')
class Records extends Table {
  TextColumn get recordId => text()();
  TextColumn get surveyMood => text()();
  TextColumn get surveyComment => text()();
  BoolColumn get status => boolean().withDefault(Constant(false))();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createDate =>
      dateTime().nullable().clientDefault(() => DateTime.now())(); // 현재시간 디폴트
  DateTimeColumn get updateDate => dateTime().nullable()();
  TextColumn get goalId => text().customConstraint(
      'REFERENCES goals(goal_id) ON DELETE CASCADE NOT NULL')(); // goal ID

  @override
  List<String> get customConstraints => ['UNIQUE (record_id)'];
}

@DriftAccessor(tables: [Records])
class RecordDao extends DatabaseAccessor<Database> with _$RecordDaoMixin {
  RecordDao(super.attachedDatabase);

  Future<List<Record>> getAllRecords() => select(records).get();
  Future<List<Record>> getRecordsByDate(DateTime startDate, DateTime endDate) =>
      (select(records)
            ..where((t) => t.date.isBetweenValues(startDate, endDate)))
          .get();
  Future<int> insertRecord(RecordsCompanion record) =>
      into(records).insert(record);
  Future<bool> updateRecord(Record record) => update(records).replace(record);
  Future<int> deleteRecord(String id) =>
      (delete(records)..where((t) => t.recordId.equals(id))).go();
  Future<Record?> getRecordById(String id) =>
      (select(records)..where((t) => t.recordId.equals(id))).getSingleOrNull();
  Future<Record?> getRecordByGoalIdAndDate(String id, DateTime selectedDay) =>
      (select(records)
            ..where((t) => t.goalId.equals(id) & t.date.equals(selectedDay)))
          .getSingleOrNull();
  Future<int> updateRecordById(String id, RecordsCompanion record) =>
      (update(records)..where((t) => t.recordId.equals(id))).write(record);
  Future<List<Record>> getRecordListByGoalId(String id) =>
      (select(records)..where((t) => t.goalId.equals(id))).get();
  Future<int> getRecordAllCnt() async {
    final query = records.selectOnly()..addColumns([records.recordId.count()]);
    final result = await query
        .map((row) => row.read(records.recordId.count()))
        .getSingle();

    return result ?? 0;
  }

  // id 생성
  Future<String> getNextCustomId() async {
    final now = DateTime.now();
    final todayPrefix = int.parse(
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}');

    // 현재 날짜와 같은 ID 중 최대값 조회
    final maxIdResults = await (select(records)
          ..where((tbl) => tbl.recordId.like('%$todayPrefix%'))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordId)]))
        .get();

    // 다음 ID 계산
    if (maxIdResults.isNotEmpty) {
      final maxId = maxIdResults.first;
      final newId = (int.parse(maxId.recordId.split("-")[1]) + 1)
          .toString()
          .padLeft(3, '0');
      return "RECORD$todayPrefix-$newId";
    } else {
      return "RECORD$todayPrefix-001";
    }
  }
}
