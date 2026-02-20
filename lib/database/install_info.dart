import 'package:drift/drift.dart';
import 'package:mogrow/database/database.dart';

part 'install_info.g.dart';

@DataClassName('InstallInfo')
class InstallInfos extends Table {
  @override
  String get tableName => 'InstallInfos'; // PascalCase로 유지
  IntColumn get id => integer().autoIncrement()(); // 단일 행 고유 식별자
  DateTimeColumn get installDate => dateTime()(); // 설치 날짜
}

@DriftAccessor(tables: [InstallInfos])
class InstallInfoDao extends DatabaseAccessor<Database>
    with _$InstallInfoDaoMixin {
  InstallInfoDao(super.attachedDatabase);

  // 설치 날짜 초기화
  Future<void> initializeInstallDate() async {
    final existingEntry = await (select(installInfos).get());
    if (existingEntry.isEmpty) {
      // 최초 실행 시 설치 날짜 기록
      await into(installInfos).insert(
        InstallInfosCompanion(
          installDate: Value(DateTime.now()),
        ),
      );
    }
  }

  // 설치 날짜 가져오기
  Future<DateTime?> getInstallDate() async {
    final entry = await (select(installInfos).getSingleOrNull());
    return entry?.installDate;
  }
}
