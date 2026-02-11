import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class RecordListProvider extends ChangeNotifier {
  final Database database;
  Record? _record;
  List<Record> _recordList = [];
  List<Record> allRecordList = [];
  late List<RecordsImage> _imageList;
  Record? _recordByDate;

  late int year;
  late int month;

  int _recordAllCnt = 0;
  int get recordAllcnt => _recordAllCnt;

  // 달성 탭 전체 기록 데이터
  List<Map<String, dynamic>> _processedRecordData = [];

  // 생성자에서 초기화 (fetchRecords 호출 전에 항상 값 보장)
  RecordListProvider(this.database) {
    final now = DateTime.now();
    year = now.year;
    month = now.month;
  }

  Record? get record => _record;
  Record? get recordByDate => _recordByDate;
  List<RecordsImage> get imageList => _imageList;
  List<Record> get recordList => _recordList;
  List<Map<String, dynamic>> get processedRecordData => _processedRecordData;

  // Custom ID 생성 함수 호출
  Future<String> getNextCustomId() async {
    return await database.recordDao.getNextCustomId();
  }

  Future<void> fetchRecords() async {
    // print("== 외래 키 상태 확인 ==");
    // await database.checkForeignKeys();
    // print("\n== 기록 테이블 확인 ==");
    // await database.checkTableSchema('records');
    // await database.checkTableSchema('todos');
    // await database.checkTableSchema('goals');

    final DateTime baseDate = DateTime(year, month);
    // 1.5년 치 데이터 조회
    final DateTime startDate = DateTime(baseDate.year, baseDate.month - 6);
    final DateTime endDate = DateTime(baseDate.year, baseDate.month + 12);

    allRecordList =
        await database.recordDao.getRecordsByDate(startDate, endDate);
    // print("$startDate ~ $endDate 기록 리스트 출력!!!!!!!!");
    // print(allRecordList);

    // 총 기록 갯수
    _recordAllCnt = await database.recordDao.getRecordAllCnt();
    // print('총 기록 갯수: $_recordAllCnt');

    notifyListeners();
  }

  Future<void> addRecord(Record record, List<AssetEntity> imageList) async {
    // print("데이터 삽입");
    // print(record);

    // 데이터베이스에 삽입
    await database.recordDao.insertRecord(
      RecordsCompanion(
        recordId: Value(record.recordId),
        surveyMood: Value(record.surveyMood),
        surveyComment: Value(record.surveyComment),
        date: Value(record.date),
        status: Value(record.status),
        goalId: Value(record.goalId),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();

    // 이미지 여러 개 저장
    for (final image in imageList) {
      // 다시 assetEntity 로 이미지를 가져오기 위함
      final assetEntityId = image.id;
      // 이미지 경로 저장
      final file = await image.file;
      if (file == null) continue;

      String originalName = file.uri.pathSegments.last;

      String filename =
          '${DateTime.now().millisecondsSinceEpoch}_${originalName.replaceAll(RegExp(r'[^\w\-_\.]'), '_')}';

      final path = '${dir.path}/$filename';

      await file.copy(path);
      // print("이미지 경로 저장!!!!");
      // print(path);

      await database.recordImageDao.insertRecordsImage(
        RecordsImagesCompanion(
          recordId: Value(record.recordId),
          assetEntityId: Value(assetEntityId),
          path: Value(path),
        ),
      );

      // blob 저장 시
      // final imageBytes = await image.originBytes;
      // if (imageBytes != null) {
      //   await database.recordImageDao.insertRecordsImage(
      // RecordsImagesCompanion(
      //   recordId: Value(record.recordId),
      //   image: Value(imageBytes),
      // ),
      //   );
      // }
    }

    await fetchRecords();
  }

  // 기록 상세 -> 목표와 날짜로 조회
  Future<void> getRecordByGoalIdAndDate(String id, DateTime selectedDay) async {
    // print('기록 상세화면!!!');

    // final all = await database.recordImageDao.getAllRecordsImage();
    // print(all);

    final getRecord =
        await database.recordDao.getRecordByGoalIdAndDate(id, selectedDay);
    // print(getRecord);

    if (getRecord != null) {
      _record = getRecord;

      _imageList =
          await database.recordImageDao.getImageByRecordId(getRecord.recordId);
      // print(_imageList);
    }

    notifyListeners();
  }

  Future<void> getRecordListByGoalId(String id) async {
    _recordList = await database.recordDao.getRecordListByGoalId(id);
    // print("목표 $id 에 대한 기록 리스트 호출!!!");
    // print(_recordList);

    // 2. 가공된 데이터를 저장할 임시 리스트
    List<Map<String, dynamic>> tempProcessedList = [];

    // 3. Record List를 순회하며 이미지 조회 및 데이터 가공
    for (var record in _recordList) {
      // 3-1. 현재 Record의 ID로 이미지 리스트 조회
      List<RecordsImage> images =
          await database.recordImageDao.getImageByRecordId(record.recordId);

      // 3-2. 원하는 형식으로 Map 생성 및 데이터 추가
      tempProcessedList.add({
        'id': record.recordId,
        'surveyComment': record.surveyComment,
        'date': record.date,
        'surveyMood': record.surveyMood,
        'createDate': record.createDate,
        'imageList': images,
      });

      // 만약 ImagesImage 객체 자체를 저장하지 않고, URL만 리스트로 저장하고 싶다면:
      // 'imageList': images.map((img) => img.imageUrl).toList(),
    }
    // print(tempProcessedList);

    // 4. 상태 업데이트
    _processedRecordData = tempProcessedList;
    notifyListeners();
  }

  Future<void> deleteRecords(String id) async {
    // DB 삭제
    await database.recordDao.deleteRecord(id);

    // 이미지 삭제
    await database.recordImageDao.deleteImageById(id);

    await fetchRecords();
  }

  Future<void> updateRecordById(String id, String mood, String comment,
      List<AssetEntity> imageList) async {
    // print("기록 수정!!!!!!");

    // 기록 업데이트
    await database.recordDao.updateRecordById(
      id,
      RecordsCompanion(
        surveyComment: Value(comment),
        surveyMood: Value(mood),
        updateDate: Value(DateTime.now()),
      ),
    );

    // 이미지 업데이트
    // 1. 기존 이미지 목록을 가져와서 비교
    // 2. 삭제된 이미지 처리 -> db, 파일
    // 3. 새로 추가된 이미지 처리
    final existingImages = await database.recordImageDao.getImageByRecordId(id);

    final updatedIds = imageList.map((e) => e.id).toSet();
    final existingIds = existingImages.map((e) => e.assetEntityId).toSet();
    // print("이미지 업데이트!!!!");
    // print(existingImages);
    // print(updatedIds);
    // print(existingIds);

    for (final image in existingImages) {
      if (!updatedIds.contains(image.assetEntityId)) {
        // DB에서 삭제
        await database.recordImageDao.deleteImage(image.assetEntityId);
        // 파일도 삭제
        final file = File(image.path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    for (final image in imageList) {
      if (!existingIds.contains(image.id)) {
        final file = await image.file;
        if (file == null) continue;

        String originalName = file.uri.pathSegments.last;

        String filename =
            '${DateTime.now().millisecondsSinceEpoch}_${originalName.replaceAll(RegExp(r'[^\w\-_\.]'), '_')}';

        final path = '${dir.path}/$filename';
        await file.copy(path);

        await database.recordImageDao.insertRecordsImage(
          RecordsImagesCompanion(
            recordId: Value(id),
            assetEntityId: Value(image.id),
            path: Value(path),
          ),
        );
      }
    }

    await fetchRecords();
  }
}
