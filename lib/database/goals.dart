import 'package:drift/drift.dart';
import 'package:mogrow/database/database.dart';

part 'goals.g.dart';

@DataClassName('Goal')
class Goals extends Table {
  TextColumn get goalId => text()();
  TextColumn get title => text()();
  TextColumn get subTitle => text().nullable()();
  TextColumn get gemstone => text()();
  TextColumn get dateDiv => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get desc => text().nullable()();
  TextColumn get reason => text().nullable()();
  BoolColumn get isCompleted =>
      boolean().withDefault(Constant(false))(); // 완료 여부
  BoolColumn get status => boolean().withDefault(Constant(false))(); // 기록 여부
  TextColumn get selectedMood => text().nullable()(); // 기록 상태
  DateTimeColumn get createDate =>
      dateTime().nullable().clientDefault(() => DateTime.now())(); // 현재시간 디폴트
  DateTimeColumn get updateDate => dateTime().nullable()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  List<String> get customConstraints => ['UNIQUE (goal_id)'];
}

@DriftAccessor(tables: [Goals])
class GoalDao extends DatabaseAccessor<Database> with _$GoalDaoMixin {
  GoalDao(super.attachedDatabase);

  Future<List<Goal>> getAllGoals() => select(goals).get();
  Future<int> insertGoal(GoalsCompanion goal) => into(goals).insert(goal);
  Future<int> updateGoal(String id, GoalsCompanion goal) =>
      (update(goals)..where((t) => t.goalId.equals(id))).write(goal);
  Future<int> updateReason(String id, String reason) =>
      (update(goals)..where((t) => t.goalId.equals(id)))
          .write(GoalsCompanion(reason: Value(reason)));
  Future<int> updateCompleted(String id, bool status) =>
      (update(goals)..where((t) => t.goalId.equals(id)))
          .write(GoalsCompanion(isCompleted: Value(status)));
  Future<int> deleteGoal(String id) =>
      (delete(goals)..where((t) => t.goalId.equals(id))).go();
  Future<Goal?> getGoalById(String id) =>
      (select(goals)..where((t) => t.goalId.equals(id))).getSingleOrNull();

  // 목표 "없음" 초기 데이터
  Future<void> initializeDate() async {
    final existingEntry = await ((select(goals)
          ..where((t) => t.goalId.equals("0000000000")))
        .get());

    if (existingEntry.isEmpty) {
      await into(goals).insert(
        GoalsCompanion(
          goalId: Value("0000000000"),
          title: Value("기타"),
          subTitle: Value("기타"),
          gemstone: Value("core"),
          dateDiv: Value("1"),
          startDate: Value(null),
          endDate: Value(null),
          desc: Value("목표 없음"),
          isCompleted: Value(false),
          status: Value(false),
          selectedMood: Value(null),
        ),
      );
    }
  }

  // id 생성
  Future<String> getNextCustomId() async {
    final now = DateTime.now();
    final todayPrefix = int.parse(
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}');

    // 현재 날짜와 같은 ID 중 최대값 조회
    final maxIdResults = await (select(goals)
          ..where((tbl) => tbl.goalId.like('%$todayPrefix%'))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.goalId)]))
        .get();

    // 다음 ID 계산
    if (maxIdResults.isNotEmpty) {
      final maxId = maxIdResults.first;
      final newId = (int.parse(maxId.goalId.split("-")[1]) + 1)
          .toString()
          .padLeft(3, '0');
      return "GOAL$todayPrefix-$newId";
    } else {
      return "GOAL$todayPrefix-001";
    }
  }

  // 달성 완료 갯수
  Future<int> getCompletedCount() async {
    final countQuery = goals.goalId.count(); // COUNT(*) 쿼리 생성
    final result = await (selectOnly(goals)
          ..addColumns([countQuery])
          ..where(goals.isCompleted.equals(true)))
        .getSingle(); // 결과를 하나만 가져옴

    return result.read(countQuery) ?? 0; // 개수 반환
  }
}
