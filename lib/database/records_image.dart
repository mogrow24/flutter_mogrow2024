import 'package:drift/drift.dart';
import 'package:mogrow/database/database.dart';
// ignore: unused_import
import 'package:mogrow/database/records.dart';

part 'records_image.g.dart';

@DataClassName('RecordsImage')
class RecordsImages extends Table {
  @override
  String get tableName => 'RecordsImages';
  IntColumn get id => integer().autoIncrement()(); // 고유 ID
  TextColumn get recordId => text().customConstraint(
      'NOT NULL REFERENCES records(record_id) ON DELETE CASCADE')();
  TextColumn get path => text()();
  TextColumn get assetEntityId => text()();
  DateTimeColumn get createDate =>
      dateTime().nullable().clientDefault(() => DateTime.now())(); // 현재시간 디폴트
  // BlobColumn get image => blob()(); // 이미지 1개

  // 컬럼별 제약조건 설정
  @override
  List<String> get customConstraints => ['UNIQUE (id)'];
}

@DriftAccessor(tables: [RecordsImages])
class RecordsImageDao extends DatabaseAccessor<Database>
    with _$RecordsImageDaoMixin {
  RecordsImageDao(super.attachedDatabase);

  Future<List<RecordsImage>> getAllRecordsImage() =>
      select(recordsImages).get();
  Future<int> insertRecordsImage(RecordsImagesCompanion image) =>
      into(recordsImages).insert(image);
  // Future<bool> updateRecord(Record record) => update(records).replace(record);
  Future<int> deleteImage(String id) =>
      (delete(recordsImages)..where((t) => t.assetEntityId.equals(id))).go();
  Future<int> deleteImageById(String id) =>
      (delete(recordsImages)..where((t) => t.recordId.equals(id))).go();
  Future<List<RecordsImage>> getImageByRecordId(String id) =>
      (select(recordsImages)..where((t) => t.recordId.equals(id))).get();
}
