import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DailyMessageWidget extends StatefulWidget {
  const DailyMessageWidget({super.key});

  @override
  State<DailyMessageWidget> createState() => _DailyMessageWidgetState();
}

class _DailyMessageWidgetState extends State<DailyMessageWidget> {
  // final dailyMsg = {
  //   'message': '많은 인생의 실패는 사람이 포기할 때 자신이 성공에 얼마나 가까이 있는지 깨닫지 못하는 것이다.',
  //   'person': '토마스 에디슨',
  // };

  List<dynamic>? messages;
  String? message;
  String? author;

  @override
  void initState() {
    super.initState();
    // message = dailyMsg['message'];
    // person = dailyMsg['person'];
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      // assets 폴더에 저장된 data.json 파일을 읽어옴
      String jsonString =
          await rootBundle.loadString('assets/datas/dailyMessage.json');
      List<dynamic> jsonData = jsonDecode(jsonString);
      // JSON 데이터에서 message와 person을 가져와 setState로 업데이트
      setState(() {
        messages = jsonData;
        int monthIndex = getMonthlyMessageIndex(messages!.length);
        message = messages![monthIndex]['message'];
        author = messages![monthIndex]['author'];
      });
    } catch (e) {
      // 오류 처리 (예: 파일이 없거나 JSON 파싱 오류)
      print('Error loading JSON: $e');
      setState(() {
        message = 'Error loading message';
        author = '';
      });
    }
  }

  // 현재 달을 기반으로 메시지 인덱스 생성
  int getMonthlyMessageIndex(int messageCount) {
    DateTime now = DateTime.now();
    int currentYear = now.year; // 현재 연도
    int currentMonth = now.month; // 현재 달
    int currentDay = now.day; // 현재 일

    return (currentYear + currentMonth + currentDay) % messageCount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 60, bottom: 0, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$message',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          Text(
            '$author',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
