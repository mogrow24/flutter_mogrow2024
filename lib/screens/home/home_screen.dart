import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/home/widget/add_todolist_widget.dart';
import 'package:mogrow/screens/home/widget/daily_message_widget.dart';
import 'package:mogrow/screens/home/widget/home_calender_widget.dart';
import 'package:mogrow/screens/home/widget/home_todolist_widget.dart';
import 'package:mogrow/screens/home/widget/title_current_day_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<DateTime> _focusedDayNotifier =
      ValueNotifier(DateTime.now());

  // late DateTime _selectedDay;

  // 텍스트 필드 포커스
  bool _isAddTodoFocused = false;

  // 명언 관련
  List<dynamic>? messages;
  String message = '';
  String author = '';

  // 달력 위치
  double topPosition = 0.0;

  @override
  void dispose() {
    _focusedDayNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 초기화면 오늘 날짜
    // DateTime today = DateTime.now();
    // _selectedDay = DateTime(today.year, today.month, today.day);

    loadJsonData(); // 명언 데이터 호출

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<TodoListProvider>(context, listen: false);
      provider.year = _focusedDayNotifier.value.year;
      provider.month = _focusedDayNotifier.value.month;
      await provider.fetchTodos();
      // print("초기 데이터 호출!!
    });
  }

  // 생명주기와 종속성 관리하는 함수
  // 종속성이 변경될 때 다시 호출. (provider)
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // final provider = Provider.of<TodoListProvider>(context, listen: false);
    // await provider.fetchTodos();
  }

  // 날짜가 변경될 때 콜백으로 처리
  void _onDateSelected(DateTime selectedDay) {
    // print(selectedDay);
    // context.read<TodoListProvider>().setSeletedDay(
    //     DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
  }

  // 텍스트 필드가 활성화 되면
  void _onFocusChanged(bool hasFocus) {
    setState(() {
      _isAddTodoFocused = hasFocus;
    });
  }

  // 명언
  Future<void> loadJsonData() async {
    try {
      // assets 폴더에 저장된 data.json 파일을 읽어옴
      String jsonString =
          await rootBundle.loadString('assets/datas/dailyMessage.json');
      List<dynamic> jsonData = jsonDecode(jsonString);

      if (jsonData.isNotEmpty) {
        // JSON 데이터에서 message와 person을 가져와 setState로 업데이트
        setState(() {
          messages = jsonData;
          int monthIndex = getMonthlyMessageIndex(messages!.length);
          message = messages![monthIndex]['message'] ?? 'No message available';
          author = messages![monthIndex]['author'] ?? 'Unknown';
          // print(message.length);
          // 메세지 길이에 따라 달력위치 조절
          if (message.length >= 114) {
            topPosition = 160.0;
          } else if (message.length >= 75 && message.length < 114) {
            topPosition = 140.0;
          } else if (message.length > 37 && message.length < 75) {
            topPosition = 120.0;
          } else {
            topPosition = 100.0;
          }
        });
      } else {
        setState(() {
          message = 'No messages found';
          author = 'Unknown';
          topPosition = 100.0;
        });
      }
    } catch (e) {
      // 오류 처리 (예: 파일이 없거나 JSON 파싱 오류)
      print('Error loading JSON: $e');
      setState(() {
        message = 'Error loading message';
        author = '';
        topPosition = 100.0;
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
    final todoProvider = Provider.of<TodoListProvider>(context, listen: false);
    final recordProvider =
        Provider.of<RecordListProvider>(context, listen: false);

    final selectedDay = context.watch<TodoListProvider>().selectedDay;

    // 명언 저장
    context.read<TodoListProvider>().updateMessage(message, author);

    return Stack(
      children: [
        if (_isAddTodoFocused)
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        SafeArea(
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
                        DailyMessageWidget(
                          message: message,
                          author: author,
                        ), // 명언
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 12,
                  // ),
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
                    height: MediaQuery.of(context).size.height * 0.11,
                  ),
                  HomeTodolistWidget(
                    selectedDay: selectedDay,
                  ),
                ],
              ),
              Positioned(
                top: topPosition, // 달력을 원하는 위치에 배치
                left: 0,
                right: 0,
                child: HomeCalendarWidget(
                  onPageChanged: (focusedDay) async {
                    final DateTime baseDate =
                        DateTime(todoProvider.year, todoProvider.month);

                    // +- 3
                    final DateTime startDate =
                        DateTime(baseDate.year, baseDate.month - 6);
                    final DateTime endDate =
                        DateTime(baseDate.year, baseDate.month + 12);

                    if ((focusedDay.isAtSameMomentAs(startDate) ||
                            focusedDay.isAfter(startDate)) &&
                        (focusedDay.isBefore(endDate) ||
                            focusedDay.isAtSameMomentAs(endDate))) {
                    } else {
                      todoProvider.year = focusedDay.year;
                      todoProvider.month = focusedDay.month;
                      recordProvider.year = focusedDay.year;
                      recordProvider.month = focusedDay.month;

                      await todoProvider.fetchTodos();
                      await recordProvider.fetchRecords();
                    }

                    _focusedDayNotifier.value = focusedDay;
                  },
                  onDateSelected: _onDateSelected,
                  // markedDates: {
                  //   for (var date in data!.keys) date: _hasData(date),
                  // },
                ), // 캘린더
              ),
              if (_isAddTodoFocused)
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom,
                child: AddTodolistWidget(
                  onFocusChanged: _onFocusChanged,
                  selectedDay: selectedDay,
                ),
              ),
            ],
          ),
        ),

        // 로딩 오버레이
        Consumer<TodoListProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
