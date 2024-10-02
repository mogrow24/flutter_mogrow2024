import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendarWidget extends StatefulWidget {
  final Function(DateTime) onPageChanged;
  final Function(DateTime) onDateSelected;
  final Map<DateTime, bool> markedDates;

  const HomeCalendarWidget(
      {required this.onPageChanged,
      super.key,
      required this.onDateSelected,
      required this.markedDates});

  @override
  State<HomeCalendarWidget> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    // 초기 화면 오늘 날짜로 선택
    DateTime today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day);
    _focusedDay = _selectedDay!;
  }

  // double _height = 300.0;
  // static const double _weekHeight = 120.0;
  // static const double _monthHeight = 380.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: Color(0xFFFFFFFF),
            height: _calendarFormat == CalendarFormat.month ? 370.0 : 120.0,
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleTextStyle: TextStyle(
                  inherit: false,
                ),
                headerPadding: EdgeInsets.only(top: 0),
              ),
              // headerVisible: false,
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
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                widget.onDateSelected(selectedDay);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (widget.markedDates[
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
                  return SizedBox(); // Return an empty widget if no marker
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
                  if (_calendarFormat == CalendarFormat.month) {
                    _calendarFormat = CalendarFormat.week;
                  } else {
                    _calendarFormat = CalendarFormat.month;
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFBEC4CE),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: 40,
                    height: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
