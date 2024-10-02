import 'package:flutter/material.dart';
import 'package:mogrow/screens/home/widget/add_todolist_widget.dart';
import 'package:mogrow/screens/home/widget/daily_message_widget.dart';
import 'package:mogrow/screens/home/widget/home_calender_widget.dart';
import 'package:mogrow/screens/home/widget/home_todolist_widget.dart';
import 'package:mogrow/screens/home/widget/title_current_day_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<DateTime> _focusedDayNotifier =
      ValueNotifier(DateTime.now());

  late DateTime _selectedDay;

  // 투두리스트 관련
  Map<DateTime, List<Map<String, dynamic>>>? data;

  @override
  void dispose() {
    _focusedDayNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 초기화면 오늘 날짜
    DateTime today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day);

    // 데이터
    data = {
      DateTime(2024, 9, 20): [
        {
          'title': '보석 아이콘 제작',
          'gemstone': 'sunstone',
          'repeat': null,
          'status': false,
          'isCompleted': false,
          'isContinue': false,
        },
        {
          'title': '엣지 케이스 그리기',
          'gemstone': 'sphene',
          'repeat': '매월 마지막 주 화요일',
          'status': false,
          'isCompleted': false,
          'isContinue': false,
        },
      ],
      DateTime(2024, 9, 15): [
        {
          'title': '디자인에 플로우 적용 후 놓친 것 다시 하기',
          'gemstone': 'aquamarine',
          'repeat': "매주 화요일",
          'status': false,
          'isCompleted': false,
          'isContinue': false,
        },
        {
          'title': '디자인 시스템 구축',
          'gemstone': 'amethyst',
          'repeat': null,
          'status': true,
          'isCompleted': false,
          'isContinue': false,
        },
      ],
    };
  }

  // api 데이터 호출 후 해당 날짜에 데이터가 있는지 확인해서 true/false
  bool _hasData(DateTime date) {
    return data?[date]?.isNotEmpty ?? false; // 데이터가 있으면 true, 없으면 false
  }

  // api 호출 시 사용
  Future<String> getTodoList() async {
    // setState(() {
    //   data!.addAll(item);
    // });
    return "success";
  }

  // 날짜가 변경될 때 콜백으로 처리
  void _onDateSelected(DateTime selectedDay) {
    print(_hasData(
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day)));
    setState(() {
      _selectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    });
  }

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
                    ValueListenableBuilder<DateTime>(
                      valueListenable: _focusedDayNotifier,
                      builder: (context, value, _) {
                        return TitleCurrentDayWidget(
                          // 타이틀 현재 날짜
                          year: value.year,
                          month: value.month,
                        );
                      },
                    ),
                    DailyMessageWidget(), // 명언
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
                height: 115,
              ),
              HomeTodolistWidget(todoList: data?[_selectedDay] ?? []),
            ],
          ),
          Positioned(
            top: 125, // 달력을 원하는 위치에 배치
            left: 0,
            right: 0,
            child: HomeCalendarWidget(
              onPageChanged: (focusedDay) {
                _focusedDayNotifier.value = focusedDay;
              },
              onDateSelected: _onDateSelected,
              markedDates: {
                for (var date in data!.keys) date: _hasData(date),
              },
            ), // 캘린더
          ),
          Positioned(
            left: 0,
            right: 80,
            bottom: MediaQuery.of(context).padding.bottom,
            child: AddTodolistWidget(),
          ),
        ],
      ),
    );
  }
}
