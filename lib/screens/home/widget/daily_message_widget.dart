import 'package:flutter/material.dart';


class DailyMessageWidget extends StatefulWidget {

  const DailyMessageWidget({super.key});

  @override
  State<DailyMessageWidget> createState() => _DailyMessageWidgetState();
}

class _DailyMessageWidgetState extends State<DailyMessageWidget> {

  final dailyMsg = {
    'message': '많은 인생의 실패는 사람이 포기할 때 자신이 성공에 얼마나 가까이 있는지 깨닫지 못하는 것이다.',
    'person' : '토마스 에디슨',
  };

  String? message;
  String? person;

  @override
  void initState() {
    super.initState();
    message = dailyMsg['message'];
    person = dailyMsg['person'];
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
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600
            ),
          ),
          Text(
            '$person',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }
}
