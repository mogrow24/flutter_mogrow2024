import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalenderWidget extends StatefulWidget {
  const HomeCalenderWidget({super.key});

  @override
  _HomeCalenderState createState() => _HomeCalenderState();
}

class _HomeCalenderState extends State<HomeCalenderWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  double _height = 90.0;
  static const double _weekHeight = 90.0;
  static const double _monthHeight = 350.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: Color(0xFFFFFFFF),
              height: _height,
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
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3E4450),
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFECEEFF),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Color(0xFF6046FF),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF6046FF),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                  ),
                  markerSize: 4,
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: Color(0xFF6046FF),
                    shape: BoxShape.circle,
                  ),
                ),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; // update `_focusedDay` here as well
                  });
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
                availableGestures: AvailableGestures.horizontalSwipe,
              ),
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _height += details.delta.dy;
                  if (_height > _monthHeight) {
                    _height = _monthHeight;
                  } else if (_height < _weekHeight ) {
                    _height = _weekHeight;
                  }
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  if (_height > (_monthHeight + _weekHeight) / 2) {
                    _height = _monthHeight;
                    _calendarFormat = CalendarFormat.month;
                  } else {
                    _height = _weekHeight;
                    _calendarFormat = CalendarFormat.week;
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
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
      }
    );
  }
}
