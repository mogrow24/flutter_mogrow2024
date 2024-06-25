import 'package:flutter/material.dart';
import 'package:momentum/screens/home/widget/daily_message_widget.dart';
import 'package:momentum/screens/home/widget/home_calender_widget.dart';
import 'package:momentum/screens/home/widget/home_todolist_widget.dart';
import 'package:momentum/screens/home/widget/title_current_day_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, right: 4, bottom: 0, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleCurrentDayWidget(), // 타이틀 현재 날짜
                    DailyMessageWidget(
                      // 명언 리스트
                      message:
                          '많은 인생의 실패는 사람이 포기할 때 자신이 성공에 얼마나 가까이 있는지 깨닫지 못하는 것이다.',
                      person: '토마스 에디슨',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffECECF0),
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 112,
              ),
              HomeTodolistWidget(),
            ],
          ),
          // Positioned(
          //   top: 166, // 달력을 원하는 위치에 배치
          //   left: 0,
          //   right: 0,
          //   child: HomeCalenderWidget(), // 캘린더
          // ),
        ],
      ),
    );
  }
}
