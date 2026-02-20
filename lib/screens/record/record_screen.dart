import 'package:flutter/material.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/home/widget/home_calender_widget.dart';
import 'package:mogrow/screens/record/widget/record_list_widget.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final ValueNotifier<DateTime> _focusedDayNotifier =
      ValueNotifier(DateTime.now());

  // late DateTime _selectedDay;

  // 투두리스트 관련
  // Map<DateTime, List<Map<String, dynamic>>>? data;

  @override
  void initState() {
    super.initState();

    // 초기화면 오늘 날짜
    // DateTime today = DateTime.now();
    // _selectedDay = DateTime(today.year, today.month, today.day);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<RecordListProvider>(context, listen: false);
      provider.year = _focusedDayNotifier.value.year;
      provider.month = _focusedDayNotifier.value.month;
      await provider.fetchRecords();
    });
  }

  @override
  void dispose() {
    _focusedDayNotifier.dispose();
    super.dispose();
  }

  // 날짜가 변경될 때 콜백으로 처리
  void _onDateSelected(DateTime selectedDay) {
    // print(_hasData(
    //     DateTime(selectedDay.year, selectedDay.month, selectedDay.day)));
    // setState(() {
    //   _selectedDay =
    //       DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    // });
  }

  // api 데이터 호출 후 해당 날짜에 데이터가 있는지 확인해서 true/false
  // bool _hasData(DateTime date) {
  //   return data?[date]?.isNotEmpty ?? false; // 데이터가 있으면 true, 없으면 false
  // }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoListProvider>(context, listen: false);
    final recordProvider =
        Provider.of<RecordListProvider>(context, listen: false);

    // final selectedDay = todoProvider.selectedDay;
    final selectedDay = context.watch<TodoListProvider>().selectedDay;

    return Stack(
      children: [
        SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      right: 4,
                      bottom: 0,
                      left: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<DateTime>(
                          valueListenable: _focusedDayNotifier,
                          builder: (context, value, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${value.year}년 ',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '${value.month}월',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                // IconButton(
                                //   highlightColor: Colors.transparent,
                                //   onPressed: () {
                                //     print("알림");
                                //   },
                                //   icon: Image.asset(
                                //     'assets/icons/notification-line.png',
                                //   ),
                                // ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
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
                    height: MediaQuery.of(context).size.height * 0.11,
                  ),
                  RecordListWidget(
                    selectedDay: selectedDay,
                  ),
                ],
              ),
              Positioned(
                top: 50,
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
