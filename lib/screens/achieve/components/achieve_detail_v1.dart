import 'package:flutter/material.dart';

class AchieveDetailV1 extends StatefulWidget {
  const AchieveDetailV1({super.key});

  @override
  State<AchieveDetailV1> createState() => _AchieveDetailV1State();
}

class _AchieveDetailV1State extends State<AchieveDetailV1> {
/*

// 했던 일/기록 toggle 관련
  List<bool> isSelected = [true, false];
  void _toggleButton(int index) {
    if (isSelected[index]) {
      // 이미 선택된 버튼을 다시 클릭할 때는 아무 동작도 하지 않음
      return;
    }
    setState(() {
      isSelected[0] = index == 0;
      isSelected[1] = index == 1;
    });
  }

  // 정렬 모달
  int? selectedArrangeIndex = 0;
  int? selectedArrangeIndex1 = 0;
  int? selectedArrangeIndex2 = 1;
  void showOrderByModal() async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          if (isSelected[0]) {
            return ShowModalOrderby(initialCheckedIndex: selectedArrangeIndex);
          } else {
            return ShowModalOrderby1(
              initialCheckedIndex: selectedArrangeIndex1,
              initialCheckedIndex1: selectedArrangeIndex2,
            );
          }
        });

    if (result != null) {
      setState(() {
        if (isSelected[0]) {
          selectedArrangeIndex = result['checkedIndex'];
        } else {
          selectedArrangeIndex1 = result['checkedIndex'];
          selectedArrangeIndex2 = result['checkedIndex1'];
        }
      });
    }
  }

  Future<void> _showCalendarModal() async {
    DateTime focusedDay = DateTime.now();

    await showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              insetPadding: EdgeInsets.all(16),
              backgroundColor: Color(0xFFFFFFFF),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all(Color(0xFFECECF0)),
                          ),
                          child: Image.asset(
                            'assets/icons/arrow_back.png',
                            color: Color(0xFF3E4450),
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(
                          '${focusedDay.year}년 ${focusedDay.month}월',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // if (selectedDay != null) {
                            //   _selectDate(selectedDay!, dateType);
                            //   Navigator.of(context).pop();
                            // }
                          },
                          style: ButtonStyle(
                            overlayColor: selectedDay != null
                                ? WidgetStateProperty.all(Color(0xFFECECF0))
                                : WidgetStateProperty.all(Colors.white),
                          ),
                          child: selectedDay != null
                              ? Image.asset(
                                  'assets/icons/check.png',
                                  color: Color(0xFF0066FA),
                                  width: 40,
                                  height: 40,
                                )
                              : Image.asset(
                                  'assets/icons/check.png',
                                  color: Colors.grey,
                                  width: 40,
                                  height: 40,
                                ),
                        ),
                      ],
                    ),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: focusedDay,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        leftChevronVisible: false,
                        rightChevronVisible: false,
                        titleTextStyle: TextStyle(
                          inherit: false,
                        ),
                        headerPadding: EdgeInsets.only(top: 0, bottom: 0),
                      ),
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
                      locale: 'ko_KR',
                      // 한국어로 설정
                      daysOfWeekHeight: 30,
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
                      onPageChanged: (newFocusedDay) {
                        print(newFocusedDay);
                        setState(() {
                          focusedDay = newFocusedDay;
                        });
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },
                      onDaySelected: (selectedDayValue, focusedDayValue) {
                        setState(() {
                          selectedDay = selectedDayValue;
                          focusedDay = focusedDayValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Container();

    /* 달성 디테일 화면의 이전 버전 */
    /*
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/gemstones/${goal.gemstone}.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dDay,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 26,
                          color: Color(0xFF000000),
                        ),
                      ),
                      goal.startDate == null
                          ? Text(
                              '기타',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xFF000000),
                              ),
                            )
                          : Text(
                              goal.dateDiv == "1"
                                  ? '${goal.startDate.toString().split(" ")[0].replaceAll("-", ".")} ~ '
                                  : '${goal.startDate.toString().split(" ")[0].replaceAll("-", ".")} ~ ${goal.endDate.toString().split(" ")[0].replaceAll("-", ".")}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xFF000000),
                              ),
                            )
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.sort,
                  size: 24,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            // color: Colors.white,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFE2E2EA),
                width: 0.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF101828).withOpacity(0.04),
                  spreadRadius: 0,
                  blurRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: !_isEditing
                      ? TextField(
                          focusNode: _textFocus,
                          controller: _controller,
                          // readOnly: _isReadOnly,
                          maxLines: 2,
                          maxLength: 50,
                          decoration: InputDecoration(
                            hintText:
                                '이 목표를 이루고 싶은 이유나 목적을 적어보세요.\n힘들어도 이 목적을 잊지말고 다시 일어나도록 도와줄거에요.',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFBEC4CE),
                            ),
                            border: InputBorder.none,
                            // contentPadding: EdgeInsets.only(
                            //   left: 15,
                            //   right: 15,
                            // ),
                            counterText: '',
                          ),
                          style: TextStyle(
                            color: Color(0xFF14161A),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          _controller.text.isEmpty
                              ? '이 목표를 이루고 싶은 이유나 목적을 적어보세요.\n힘들어도 이 목적을 잊지말고 다시 일어나도록 도와줄거에요.'
                              : _controller.text,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: _controller.text.isEmpty
                                  ? Color(0xFFBEC4CE)
                                  : Color(0xFF14161A)),
                        ),
                ),
                _isEditing
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).requestFocus(_textFocus);
                          });
                        },
                        icon: Image.asset(
                          'assets/icons/edit.png',
                          width: 20,
                          height: 20,
                          color: Color(0xFF8892A6),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        icon: Image.asset(
                          'assets/icons/check.png',
                          width: 20,
                          height: 20,
                          color: Color(0xFF6046FF),
                        ),
                      )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            top: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...[0, 1].map((index) {
                final screenWidth = MediaQuery.of(context).size.width;
                final buttonWidth = (screenWidth - 40 - 16) / 2;

                return TextButton(
                  onPressed: () {
                    _toggleButton(index);
                  },
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    overlayColor:
                        WidgetStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Container(
                    width: buttonWidth,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isSelected[index]
                          ? Color(0xFF6046FF)
                          : Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFE2E2EA),
                        width: 0.1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF101828).withOpacity(0.04),
                          blurRadius: 2.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        index == 0 ? '목표를 위해 했던 일' : '나의 과정 기록',
                        style: TextStyle(
                          color:
                              isSelected[index] ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(
        //     right: 25,
        //   ),
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: SizedBox(
        //       width: 80,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           SizedBox(
        //             width: 20,
        //             height: 20,
        //             child: IconButton(
        //               padding: EdgeInsets.zero,
        //               constraints: BoxConstraints(),
        //               highlightColor: Colors.transparent,
        //               onPressed: () {},
        //               icon: Icon(
        //                 Icons.search,
        //                 color: Color(0xff667086),
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             width: 20,
        //             height: 20,
        //             child: IconButton(
        //               padding: EdgeInsets.zero,
        //               constraints: BoxConstraints(),
        //               highlightColor: Colors.transparent,
        //               onPressed: () {
        //                 _showCalendarModal();
        //               },
        //               icon: Image.asset(
        //                 'assets/icons/date_range.png',
        //                 color: Color(0xff667086),
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             width: 20,
        //             height: 20,
        //             child: IconButton(
        //               padding: EdgeInsets.zero,
        //               constraints: BoxConstraints(),
        //               highlightColor: Colors.transparent,
        //               onPressed: () {
        //                 showOrderByModal();
        //               },
        //               icon: Image.asset(
        //                 'assets/icons/sort.png',
        //                 color: Color(0xff667086),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(12, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: currentMonthNotifier,
                    builder: (context, currentMonth, child) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: currentMonth == (index + 1)
                              ? Color(0xff6046ff)
                              : Color(0xffececf0),
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          overlayColor: Colors.transparent,
                        ),
                        onPressed: () {
                          currentMonthNotifier.value = index + 1;
                        },
                        child: Text(
                          index < 9 ? '0${index + 1}월' : '${index + 1}월',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: currentMonth == (index + 1)
                                ? Color(0xffffffff)
                                : Color(0xff000000),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ),
        isSelected[0]
            ? Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    // left: 20,
                    // right: 20,
                    top: 15,
                    bottom: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Color(0xFFFFFFFF),
                        // borderRadius: BorderRadius.circular(8),
                        // border: Border.all(
                        //   color: Color(0xFFE2E2EA),
                        //   width: 1,
                        // ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0xFF101828).withOpacity(0.04),
                        //     spreadRadius: 0,
                        //     blurRadius: 2.0,
                        //     offset: Offset(0, 2),
                        //   ),
                        // ],
                        ),
                    child: ValueListenableBuilder<int>(
                      valueListenable: currentMonthNotifier,
                      builder: (context, currentMonth, child) {
                        final currentTodoList = todoList
                            .where((item) => item.date?.month == currentMonth)
                            .toList();

                        Map<DateTime, List<Todo>> groupedList = {};
                        for (var item in currentTodoList) {
                          DateTime date = item.date!;
                          DateTime normal =
                              DateTime(date.year, date.month, date.day);
                          if (!groupedList.containsKey(normal)) {
                            groupedList[normal] = [];
                          }
                          groupedList[normal]!.add(item);
                        }
                        List<DateTime> sort = groupedList.keys.toList()
                          ..sort((a, b) => b.compareTo(a));

                        return currentTodoList.isEmpty
                            ? Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '아직 이번 달의 한 일이 없어요',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF8892A6),
                                      ),
                                    ),
                                    Text(
                                      '목표 달성을 위해 할 일을 적어보세요',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF8892A6),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // context.go 를 사용하면 깨지는 현상
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Color(0xFF6046FF)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                        ),
                                        child: Text(
                                          '할 일 적으러 가기',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: sort.length,
                                itemBuilder: (context, index) {
                                  DateTime date = sort[index];
                                  List<Todo> items = groupedList[date]!;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 24,
                                      right: 24,
                                      bottom: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(date),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff667086),
                                              ),
                                            ),
                                            Icon(
                                              Icons.person_4,
                                            ),
                                          ],
                                        ),
                                        ...items.map(
                                          (item) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '- ${item.title}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff14161a)),
                                              ),
                                              Icon(
                                                Icons.ac_unit_outlined,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                      },
                    ),
                  ),
                ),
              )
            : Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    // left: 20,
                    // right: 20,
                    top: 15,
                    bottom: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Color(0xFFFFFFFF),
                        // borderRadius: BorderRadius.circular(8),
                        // border: Border.all(
                        //   color: Color(0xFFE2E2EA),
                        //   width: 1,
                        // ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0xFF101828).withOpacity(0.04),
                        //     spreadRadius: 0,
                        //     blurRadius: 2.0,
                        //     offset: Offset(0, 2),
                        //   ),
                        // ],
                        ),
                    child: ValueListenableBuilder<int>(
                      valueListenable: currentMonthNotifier,
                      builder: (context, currentMonth, child) {
                        final currentTodoList = todoList
                            .where((item) => item.date?.month == currentMonth)
                            .toList();

                        Map<DateTime, List<Todo>> groupedList = {};
                        for (var item in currentTodoList) {
                          DateTime date = item.date!;
                          DateTime normal =
                              DateTime(date.year, date.month, date.day);
                          if (!groupedList.containsKey(normal)) {
                            groupedList[normal] = [];
                          }
                          groupedList[normal]!.add(item);
                        }
                        List<DateTime> sort = groupedList.keys.toList()
                          ..sort((a, b) => b.compareTo(a));

                        int crossAxisCount = tempGridList.length == 1
                            ? 1
                            : tempGridList.length == 2
                                ? 2
                                : 3;

                        return currentTodoList.isEmpty
                            ? Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '아직 이번 달의 기록이 없어요',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF8892A6),
                                      ),
                                    ),
                                    Text(
                                      '오늘부터라도 기록해 보세요',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF8892A6),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // context.go 를 사용하면 깨지는 현상
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Color(0xFF6046FF)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                        ),
                                        child: Text(
                                          '오늘의 기록 남기러 가기',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: selectedArrangeIndex2 == 1
                                    ? buildGridView(
                                        tempGridList, crossAxisCount)
                                    : buildListView(tempGridList),
                              );
                      },
                    ),
                  ),
                ),
              )
      ],
    );
    */
  }
}
