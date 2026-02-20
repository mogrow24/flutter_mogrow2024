import 'package:flutter/material.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendarWidget extends StatefulWidget {
  final Function(DateTime) onPageChanged;
  final Function(DateTime) onDateSelected;

  const HomeCalendarWidget({
    required this.onPageChanged,
    super.key,
    required this.onDateSelected,
  });

  @override
  State<HomeCalendarWidget> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendarWidget> {
  // CalendarFormat _calendarFormat = CalendarFormat.week;
  // DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    // 초기 화면 오늘 날짜로 선택
    // DateTime today = DateTime.now();
    // _selectedDay = DateTime(today.year, today.month, today.day);
    // _focusedDay = _selectedDay!;
  }

  int _getRowCount(DateTime focusedDay) {
    // 해당 월의 첫 날과 마지막 날을 구합니다.
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDayOfMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    // 첫 주 시작 요일과 마지막 주 끝 요일을 포함해 총 며칠이 필요한지 계산합니다.
    // TableCalendar의 기본 설정(일요일 시작) 기준입니다.
    final daysBefore = firstDayOfMonth.weekday % 7;
    final totalDays = daysBefore + lastDayOfMonth.day;

    // 7로 나누어 올림하면 해당 월의 주차(행 수)가 나옵니다.
    return (totalDays / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);
    final selectedDay = provider.selectedDay;
    final focusedDay = provider.focusedDay;
    final calendarFormat = provider.calendarFormat;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: Color(0xFFFFFFFF),
            height: calendarFormat == CalendarFormat.month
                ? (_getRowCount(focusedDay) * 52.0) + 54.0
                : 108.0,
            child: TableCalendar(
              firstDay: DateTime.now().subtract(Duration(days: 365 * 50)),
              lastDay: DateTime.now().add(Duration(days: 365 * 50)),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle: TextStyle(
                  inherit: false,
                ),
                headerPadding: EdgeInsets.only(
                  bottom: 6,
                ),
              ),
              headerVisible: false,
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3E4450),
                ),
                weekendTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3E4450),
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFE0ECFF),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: Color(0xFF0066FA),
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF0066FA),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                ),
                // markerSize: 4,
                // markersMaxCount: 1,
                // markerDecoration: BoxDecoration(
                //   color: Color(0xFF6046FF),
                //   shape: BoxShape.circle,
                // ),
              ),
              focusedDay: focusedDay,
              calendarFormat: calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                context.read<TodoListProvider>().setSeletedDay(DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day));

                // widget.onDateSelected(selectedDay);
                context
                    .read<TodoListProvider>()
                    .setCalendarFormat(CalendarFormat.week);
              },
              onFormatChanged: (format) {
                if (calendarFormat != format) {
                  context.read<TodoListProvider>().setCalendarFormat(format);
                  // setState(() {
                  //   _calendarFormat = format;
                  // });
                }
              },
              onPageChanged: (focusedDay) {
                context.read<TodoListProvider>().setFocusedDay(DateTime(
                    focusedDay.year, focusedDay.month, focusedDay.day));
                widget.onPageChanged(focusedDay); // 페이지 변경 시 상위 위젯에 알림
              },
              locale: 'ko_KR',
              // 한국어로 설정
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667086),
                ),
                weekdayStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF667086),
                ),
              ),
              daysOfWeekHeight: 25,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (provider.dateHasDataMap[
                          DateTime(date.year, date.month, date.day)] ==
                      true) {
                    return Opacity(
                      opacity: 0.4,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Color(0xFF0066FA),
                          shape: BoxShape.circle,
                        ),
                        width: 5.0,
                        height: 5.0,
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              availableGestures: AvailableGestures.horizontalSwipe,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              // onVerticalDragUpdate: (details) {
              //   setState(() {
              //     _height -= details.delta.dy;
              //     print(_height);
              //     if (_height > _monthHeight) {
              //       _height = _monthHeight;
              //       print(_monthHeight);
              //       print('month');
              //     } else if (_height < _weekHeight) {
              //       _height = _weekHeight;
              //       print(_weekHeight);
              //       print('week');
              //     }
              //   });
              // },
              onVerticalDragEnd: (details) {
                setState(() {
                  // if (_height > (_monthHeight + _weekHeight) / 2) {
                  //   _height = _monthHeight;
                  //   _calendarFormat = CalendarFormat.month;
                  // } else {
                  //   _height = _weekHeight;
                  //   _calendarFormat = CalendarFormat.week;
                  // }
                  if (calendarFormat == CalendarFormat.month) {
                    context
                        .read<TodoListProvider>()
                        .setCalendarFormat(CalendarFormat.week);
                    // _calendarFormat = CalendarFormat.week;
                  } else {
                    context
                        .read<TodoListProvider>()
                        .setCalendarFormat(CalendarFormat.month);
                    // _calendarFormat = CalendarFormat.month;
                  }
                });
              },
              child: Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffECECF0),
                      width: 1,
                    ),
                  ),
                  boxShadow: calendarFormat == CalendarFormat.month
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFBEC4CE),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 40,
                        height: 4,
                      ),
                    ),
                    calendarFormat == CalendarFormat.month
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size.zero,
                                overlayColor: Colors.transparent,
                              ),
                              onPressed: () {
                                final now = DateTime.now();
                                context.read<TodoListProvider>().setSeletedDay(
                                    DateTime(now.year, now.month, now.day));

                                widget.onDateSelected(DateTime.now());
                                widget.onPageChanged(DateTime.now());
                                setState(() {
                                  // _focusedDay = DateTime.now();
                                  // _selectedDay = DateTime.now();
                                });
                              },
                              child: Text(
                                '오늘',
                                style: TextStyle(
                                  color: Color(0xFF0066FA),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
