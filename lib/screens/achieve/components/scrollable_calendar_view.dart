import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ScrollableCalendarView extends StatefulWidget {
  final Goal goal;
  final Map<DateTime, bool> dateHasDataMap;
  final Map<DateTime, bool> recordHasDataMap;

  const ScrollableCalendarView(
      {super.key,
      required this.goal,
      required this.dateHasDataMap,
      required this.recordHasDataMap});

  @override
  State<ScrollableCalendarView> createState() => _ScrollableCalendarViewState();
}

class _ScrollableCalendarViewState extends State<ScrollableCalendarView> {
  final ScrollController _scrollController = ScrollController();
  final int _loadCount = 3;
  // final double _calendarHeight = 330;
  static const double _itemPaddingVertical = 16;

  final List<DateTime> _monthList = [];
  // final bool _isLoading = false;
  bool _isLoadingTop = false;
  bool _isLoadingBottom = false;

  late int _todayIndex;

  final DateTime startMonth = DateTime.now().subtract(Duration(days: 365 * 50));
  final DateTime endMonth = DateTime.now().add(Duration(days: 365 * 50));
  final DateTime today = DateTime.now();

  // int _monthDiff(DateTime start, DateTime end) {
  //   return (end.year - start.year) * 12 + end.month - start.month;
  // }

  // int getTodayIndex() {
  //   return (today.year - startMonth.year) * 12 +
  //       (today.month - startMonth.month);
  // }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    for (int i = -3; i <= 3; i++) {
      _monthList.add(DateTime(now.year, now.month + i));
    }

    _todayIndex = 3;

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      if (_scrollController.position.pixels <= 0 &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        _prependMonths();
      } else if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _appendMonths();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final targetOffset = _todayIndex * _calendarHeight;
      if (!_scrollController.hasClients) return;
      double targetOffset = 0;
      for (int i = 0; i < _todayIndex && i < _monthList.length; i++) {
        targetOffset += getCalendarHeight(getWeekCount(_monthList[i])) +
            _itemPaddingVertical;
      }
      _scrollController.jumpTo(targetOffset);
    });
  }

  void _prependMonths() async {
    if (_isLoadingTop) return;
    setState(() => _isLoadingTop = true);

    final first = _monthList.first;
    final oldScrollOffset = _scrollController.offset;
    List<DateTime> newMonths = [];
    for (int i = _loadCount; i >= 1; i--) {
      newMonths.add(DateTime(first.year, first.month - i));
    }

    // await Future.delayed(Duration(milliseconds: 300));
    // prepend할 달들의 실제 높이 합으로 스크롤 보정 (월별 주 수가 달라서 고정값 사용 시 화면이 어긋남)
    double prependedHeight = 0;
    for (final m in newMonths) {
      prependedHeight +=
          getCalendarHeight(getWeekCount(m)) + _itemPaddingVertical;
    }

    setState(() {
      _monthList.insertAll(0, newMonths);
      _todayIndex += _loadCount;
      _isLoadingTop = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _scrollController.position.hold(() {}); // 스크롤 관성 멈춤
      // _scrollController.jumpTo(oldScrollOffset + _calendarHeight * _loadCount);
      // setState(() => _isLoadingTop = false);
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(oldScrollOffset + prependedHeight);
    });
  }

  void _appendMonths() async {
    if (_isLoadingBottom) return;
    setState(() => _isLoadingBottom = true);

    final last = _monthList.last;
    List<DateTime> newMonths = [];
    for (int i = 1; i <= _loadCount; i++) {
      newMonths.add(DateTime(last.year, last.month + i));
    }

    setState(() {
      _monthList.addAll(newMonths);
    });

    await Future.delayed(Duration(milliseconds: 300));

    setState(() => _isLoadingBottom = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int getWeekCount(DateTime month,
      {StartingDayOfWeek startOfWeek = StartingDayOfWeek.sunday}) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final totalDays = last.day;

    // 요일 기준을 0~6으로 바꿈 (sunday=0, monday=1, ..., saturday=6)
    final int firstWeekday =
        (first.weekday % 7); // DateTime.weekday: mon=1 ~ sun=7
    final int startWeekday = _getStartWeekdayIndex(startOfWeek);

    // offset: 첫날이 주의 어디에 위치하는지
    final int offset = (firstWeekday - startWeekday + 7) % 7;
    final totalCells = offset + totalDays;

    final rowCount = (totalCells / 7).ceil();
    return rowCount;
  }

  int _getStartWeekdayIndex(StartingDayOfWeek startOfWeek) {
    switch (startOfWeek) {
      case StartingDayOfWeek.monday:
        return 1;
      case StartingDayOfWeek.tuesday:
        return 2;
      case StartingDayOfWeek.wednesday:
        return 3;
      case StartingDayOfWeek.thursday:
        return 4;
      case StartingDayOfWeek.friday:
        return 5;
      case StartingDayOfWeek.saturday:
        return 6;
      case StartingDayOfWeek.sunday:
      default:
        return 0;
    }
  }

  double getCalendarHeight(int weekCount) {
    const rowHeight = 70.0; // 각 주의 높이
    const headerHeight = 20.0; // 달 제목 + 요일 표시
    return rowHeight * weekCount + headerHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: _monthList.length + (_isLoadingTop ? 1 : 0),
          itemBuilder: (context, index) {
            if (_isLoadingTop && index == 0) {
              return Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final actualIndex = _isLoadingTop ? index - 1 : index;
            final month = _monthList[actualIndex];
            final weekCount = getWeekCount(month);
            final calendarHeight = getCalendarHeight(weekCount);
            final focusedDay = DateTime(month.year, month.month, 1);

            return Container(
              height: calendarHeight,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 6,
                    ),
                    child: Text(
                      '${month.year}년 ${month.month}월',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCalendar(
                    firstDay: DateTime.now().subtract(Duration(days: 365 * 50)),
                    lastDay: DateTime.now().add(Duration(days: 365 * 50)),
                    focusedDay: focusedDay,
                    headerVisible: false,
                    daysOfWeekVisible: true,
                    calendarFormat: CalendarFormat.month,
                    availableGestures: AvailableGestures.none,
                    calendarStyle: CalendarStyle(
                      // isTodayHighlighted: false,
                      // todayDecoration: BoxDecoration(),
                      // selectedDecoration: BoxDecoration(),
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
                      // todayDecoration: BoxDecoration(
                      //   color: Color(0xFFE0ECFF),
                      //   shape: BoxShape.circle,
                      // ),
                      // todayTextStyle: TextStyle(
                      //   color: Color(0xFF0066FA),
                      // ),
                      // selectedDecoration: BoxDecoration(
                      //   color: Color(0xFF0066FA),
                      //   shape: BoxShape.circle,
                      // ),
                      // selectedTextStyle: TextStyle(
                      //   color: Color(0xFFFFFFFF),
                      //   fontWeight: FontWeight.w600,
                      // ),
                    ),
                    onDaySelected: (selected, focused) async {
                      final dayKey =
                          DateTime(selected.year, selected.month, selected.day);

                      // 1. 해당 날짜에 데이터가 있는지 확인
                      final todoCheck = widget.dateHasDataMap[dayKey] ?? false;
                      final recordCheck =
                          widget.recordHasDataMap[dayKey] ?? false;

                      // 2. 데이터가 있다면 화면 이동 함수 호출
                      if (todoCheck && recordCheck) {
                        // _navigateToRecordPage(selected);
                        final updatedRecord = await context.push(
                          '/recordSurveyDetail',
                          extra: {
                            'gemstone': widget.goal.gemstone,
                            'title': widget.goal.title,
                            'selectedDay': dayKey,
                            'goalId': widget.goal.goalId,
                          },
                        );

                        if (updatedRecord == true) {
                          await context
                              .read<RecordListProvider>()
                              .getRecordListByGoalId(widget.goal.goalId);
                        }
                      } else if (todoCheck && !recordCheck) {
                        // 기록이 없을 때
                        print("기록이 없어요!");
                      } else {
                        // 데이터가 없는 경우 (선택은 되지만 아무 일도 일어나지 않음)
                        // print('데이터가 없어 이동하지 않습니다: $dayKey');
                      }
                    },
                    // selectedDayPredicate: (day) {
                    //   return isSameDay(selectedDay, day);
                    // },
                    locale: 'ko_KR',
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
                      // markerBuilder: (context, date, events) {
                      //   if (provider.dateHasDataMap[
                      //           DateTime(date.year, date.month, date.day)] ==
                      //       true) {
                      //     return Opacity(
                      //       opacity: 0.4,
                      //       child: Container(
                      //         margin: const EdgeInsets.symmetric(vertical: 1.5),
                      //         decoration: BoxDecoration(
                      //           color: Color(0xFF0066FA),
                      //           shape: BoxShape.circle,
                      //         ),
                      //         width: 5.0,
                      //         height: 5.0,
                      //       ),
                      //     );
                      //   }
                      //   return SizedBox();
                      // },
                      defaultBuilder: (context, day, focusedDay) {
                        final dayKey = DateTime(day.year, day.month, day.day);

                        final todoCheck =
                            widget.dateHasDataMap[dayKey] ?? false;

                        final recordCheck =
                            widget.recordHasDataMap[dayKey] ?? false;

                        if (todoCheck && recordCheck) {
                          return _buildFilledCircle(day); // 색 채운 동그라미
                        } else if (todoCheck) {
                          return _buildOutlinedCircle(day); // 테두리만 있는 동그라미
                        } else {
                          return _buildDisabledDay(day); // 흐리게
                        }
                      },
                      todayBuilder: (context, day, focusedDay) {
                        final dayKey = DateTime(day.year, day.month, day.day);

                        final todoCheck =
                            widget.dateHasDataMap[dayKey] ?? false;

                        final recordCheck =
                            widget.recordHasDataMap[dayKey] ?? false;

                        if (todoCheck && recordCheck) {
                          return _buildFilledCircle(day); // 색 채운 동그라미
                        } else if (todoCheck) {
                          return _buildOutlinedCircle(day); // 테두리만 있는 동그라미
                        } else {
                          return _buildDisabledDay(day); // 흐리게
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildFilledCircle(DateTime day) {
  return Center(
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Color(0xFF0066FA),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _buildOutlinedCircle(DateTime day) {
  return Center(
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF0066FA), width: 2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: Color(0xFF0066FA),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _buildDisabledDay(DateTime day) {
  return Center(
    child: Text(
      '${day.day}',
      style: TextStyle(
        color: Colors.grey,
      ),
    ),
  );
}
