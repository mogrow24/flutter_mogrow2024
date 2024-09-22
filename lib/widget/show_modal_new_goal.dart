import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momentum/widget/show_modal_description.dart';
import 'package:momentum/widget/show_modal_select_goalColor.dart';
import 'package:table_calendar/table_calendar.dart';

class FullScreenModal extends StatefulWidget {
  const FullScreenModal({super.key});

  @override
  State<FullScreenModal> createState() => _FullScreenModalState();
}

class _FullScreenModalState extends State<FullScreenModal> {
  // title 관련
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerSubtitle = TextEditingController();
  int _characterCountTitle = 0;
  int _characterCountSubtitle = 0;
  final int _maxLengthTitle = 40;
  final int _maxLengthSubtitle = 40;
  final int _maxLines = 3;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _subtitleFocus = FocusNode();

  // 날짜수, 디데이 toggle 관련
  List<bool> isSelected = [true, false];

  // 날짜 관련
  final DateTime today = DateTime.now();
  DateTime tomorrow = DateTime.now().add(Duration(days: 1));
  DateTime? selectedDay;
  List<String> todayList = DateFormat('EEEE, yyyy-MM-dd', 'ko_KR')
      .format(DateTime.now())
      .split(', ');
  List<String> tomorrowList = DateFormat('EEEE, yyyy-MM-dd', 'ko_KR')
      .format(DateTime.now().add(Duration(days: 1)))
      .split(', ');
  String? _dateOrDday;
  String? _dateday;
  String _startDate = '';
  String _endDate = '';

  // 캘린더
  DateTime? _startCalendarDate;
  DateTime? _endCalendarDate;

  // 목표 색상 관련
  String? selectedImage = 'core.png';
  String? selectedName;

  // 필수 항목 체크
  bool? checkTitle;
  bool? checkSubtitle;

  // 설명 관련
  String desc = '';

  @override
  void initState() {
    super.initState();
    _startDate = '${todayList[1]} (${todayList[0].substring(0, 1)})';
    _endDate = '${tomorrowList[1]} (${tomorrowList[0].substring(0, 1)})';
    _dateOrDday = 'D-${tomorrow.difference(today).inDays}';
    _dateday = 'D+${tomorrow.difference(today).inDays}';
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCountTitle = _controllerTitle.text.length;
      _characterCountSubtitle = _controllerSubtitle.text.length;
    });
  }

  void _showGoalColorSelectionModal() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return ShowModalSelectGoalColor();
      },
    );
    if (result != null) {
      setState(() {
        selectedImage = result['image'];
        selectedName = result['name'];
      });
    }
  }

  void _selectDate(DateTime selectedDate, String dateType) {
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);

    setState(() {
      if (dateType == 'start') {
        // 시작날짜
        // 캘린더 내부 값에 저장
        _startCalendarDate = selectedDate;

        // 시작, 종료일 text 포맷
        _startDate = _formatDate(selectedDate);

        // 날짜 차이 계산
        Duration diff;

        if (isSelected[0]) {
          // 날짜수 일 때
          diff = selectedDate.difference(todayWithoutTime).inDays <= 0
              ? selectedDate.difference(todayWithoutTime) + Duration(days: -1)
              : selectedDate.difference(todayWithoutTime);
          _dateday = diff.inDays < 0 ? 'D+${-diff.inDays}' : 'D-${diff.inDays}';
        } else {
          // 디데이 일 때
          DateTime endDate = DateTime.parse(_endDate.split(' (')[0]);

          // 시작일이 종료일 보다 이후일 때
          if (selectedDate.isAfter(endDate)) {
            endDate = selectedDate.add(Duration(days: 1));

            _endDate = _formatDate(endDate);
            _endCalendarDate = endDate;
            _dateOrDday = 'D-1';
          } else {
            diff = selectedDate.difference(_endCalendarDate ?? endDate);
            _dateOrDday =
                diff.isNegative ? 'D-${-diff.inDays}' : 'D-${diff.inDays}';
          }
        }
      } else {
        // 종료날짜
        // 캘린더 내부 값에 저장
        _endCalendarDate = selectedDate;

        // 종료일 text
        _endDate = _formatDate(selectedDate);

        // 시작날짜
        DateTime startDate = DateTime.parse(_startDate.split(' (')[0]);

        if (selectedDate.isBefore(startDate)) {
          // 종료일이 시작일보다 이전인 경우
          startDate = selectedDate.subtract(Duration(days: 1));

          _startDate = _formatDate(startDate);
          _startCalendarDate = startDate;
          _dateOrDday = 'D-1';

          // 종료일이 시작일보다 이전인 경우 에러 메시지 표시
          // _showErrorDialog('종료일은 시작일 이후여야 합니다.');
          // return;
        } else {
          // 날짜 차이 계산 (디데이)
          Duration diff = selectedDate.difference(startDate);
          _dateOrDday =
              diff.isNegative ? 'D-${-diff.inDays}' : 'D-${diff.inDays}';
        }
      }
    });
  }

  Future<void> _showCalendarModal(String dateType) async {
    DateTime? selectedDay =
        dateType == 'start' ? _startCalendarDate : _endCalendarDate;
    DateTime focusedDay = selectedDay ?? DateTime.now();

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
                            if (selectedDay != null) {
                              _selectDate(selectedDay!, dateType);
                              Navigator.of(context).pop();
                            }
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

  String _formatDate(DateTime date) {
    final List<String> dateList =
        DateFormat('EEEE, yyyy-MM-dd', 'ko_KR').format(date).split(', ');
    return '${dateList[1]} (${dateList[0].substring(0, 1)})';
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _subtitleFocus.dispose();
    _controllerTitle.dispose();
    _controllerSubtitle.dispose();
    super.dispose();
  }

  // 유효성 검사 함수
  bool _validateInputs() {
    setState(() {
      checkTitle = _controllerTitle.text.isEmpty ? false : true;

      checkSubtitle = _controllerSubtitle.text.isEmpty ? false : true;
    });

    return checkTitle != false && checkSubtitle != false;
  }

  // 날짜수, 디데이 토글
  void _toggleButton(int index) {
    if (isSelected[index]) {
      // 이미 선택된 버튼을 다시 클릭할 때는 아무 동작도 하지 않음
      return;
    }
    setState(() {
      isSelected[0] = index == 0;
      isSelected[1] = index == 1;

      if (index == 0) {
        _startCalendarDate = null;
        _endCalendarDate = null;
        _startDate = '${todayList[1]} (${todayList[0].substring(0, 1)})';
        _dateday = 'D+1';
      } else if (index == 1) {
        _startCalendarDate = null;
        _endCalendarDate = null;
        _startDate = '${todayList[1]} (${todayList[0].substring(0, 1)})';
        _endDate = '${tomorrowList[1]} (${tomorrowList[0].substring(0, 1)})';
        _dateOrDday = 'D-1';
      }
    });
  }

  // 설명 모달
  void _showDescriptionModal() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ShowModalDescription(initDesc: desc,);
      },
    );

    if (result != null) {
      setState(() {
        desc = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocus.unfocus();
        _subtitleFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '목표 만들기',
            style: TextStyle(
              color: Color(0xFF14161A),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              'assets/icons/arrow_down.png',
              width: 40,
              height: 40,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_characterCountTitle > 0) {
                  print('완료');
                }
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.white),
              ),
              child: _validateInputs()
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xffF6F6F8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: TextField(
                              focusNode: _titleFocus,
                              controller: _controllerTitle,
                              maxLength: _maxLengthTitle,
                              maxLines: _maxLines,
                              decoration: InputDecoration(
                                hintText: '제목',
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8892A6),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                counterText: '',
                                // counterStyle: TextStyle(
                                //   fontSize: 12,
                                //   fontWeight: FontWeight.w400,
                                //   color: Color(0xFF8892A6),
                                // ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF14161A),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              onChanged: (text) {
                                _updateCharacterCount();
                              },
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_subtitleFocus),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: TextField(
                              focusNode: _subtitleFocus,
                              controller: _controllerSubtitle,
                              maxLength: _maxLengthSubtitle,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: '세부 제목',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8892A6),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                counterText:
                                    '$_characterCountSubtitle/$_maxLengthSubtitle',
                                counterStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF8892A6),
                                ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF14161A),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (text) {
                                _updateCharacterCount();
                              },
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) =>
                                  FocusScope.of(context).unfocus(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          _showGoalColorSelectionModal();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 70,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/gemstones/$selectedImage',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      '색상',
                                      style: TextStyle(
                                          color: Color(0xFF14161A),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                selectedName ?? '없음',
                                style: TextStyle(
                                    color: Color(0xFF3E4450),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 28,
                        child: Text(
                          '기간 설정',
                          style: TextStyle(
                            color: Color(0xFF3E4450),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    // height: 168,
                    height: isSelected[0] ? 210 : 168,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                              ),
                              // ToggleButtons(
                              //   disabledColor: Colors.white,
                              //   renderBorder: false,
                              //   borderRadius: BorderRadius.circular(10),
                              //   borderWidth: 0,
                              //   borderColor: Colors.white,
                              //   selectedBorderColor: Colors.white,
                              //   fillColor: Colors.blue,
                              //   color: Colors.grey,
                              //   selectedColor: Colors.black,
                              //   isSelected: isSelected,
                              //   onPressed: (index) {
                              //     setState(() {
                              //       for (int buttonIndex = 0;
                              //           buttonIndex < isSelected.length;
                              //           buttonIndex++) {
                              //         if (buttonIndex == index) {
                              //           isSelected[buttonIndex] = true;
                              //         } else {
                              //           isSelected[buttonIndex] = false;
                              //         }
                              //       }
                              //       _dateOrDday =
                              //           isSelected[0] ? '+19' : '0000-00-00 (월)';
                              //     });
                              //   },
                              //   children: [
                              //     Padding(
                              //       padding: EdgeInsets.symmetric(horizontal: 20),
                              //       child: Text(
                              //         '날짜수',
                              //         style: TextStyle(
                              //           color: isSelected[0]
                              //               ? Color(0xFF0066FA)
                              //               : Color(0xFF3E4450),
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: EdgeInsets.symmetric(horizontal: 20),
                              //       child: Text(
                              //         '디데이',
                              //         style: TextStyle(
                              //           color: isSelected[1]
                              //               ? Color(0xFF0066FA)
                              //               : Color(0xFF3E4450),
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: isSelected[0]
                                        ? Color(0xFF0066FA)
                                        : Color(0xFFECECF0),
                                    // primary: isSelected[1] ? Colors.blue : Colors.grey,
                                    // onPrimary: isSelected[1] ? Colors.white : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: Size(70, 30),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 16)),
                                onPressed: () => _toggleButton(0),
                                child: Text(
                                  '날짜수',
                                  style: TextStyle(
                                    color: isSelected[0]
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xFF3E4450),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: isSelected[1]
                                      ? Color(0xFF0066FA)
                                      : Color(0xFFECECF0),
                                  // primary: isSelected[1] ? Colors.blue : Colors.grey,
                                  // onPrimary: isSelected[1] ? Colors.white : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(70, 30),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                ),
                                onPressed: () => _toggleButton(1),
                                child: Text(
                                  '디데이',
                                  style: TextStyle(
                                    color: isSelected[1]
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xFF3E4450),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              VerticalDivider(
                                color: Color(0xFFECECF0),
                                thickness: 1,
                                indent: 15,
                                endIndent: 15,
                              ),
                              // Spacer(),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                isSelected[0] ? '$_dateday' : '$_dateOrDday',
                                // _dateOrDday!.inDays == 0
                                //     ? 'D-day'
                                //     : _dateOrDday!.inDays < 0
                                //         ? 'D${_dateOrDday?.inDays}'
                                //         : 'D+${_dateOrDday?.inDays}',
                                style: TextStyle(
                                  color: Color(0xFF3E4450),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: GestureDetector(
                                  onTap: () => _showCalendarModal('start'),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/icons/date_range.png',
                                        color: Color(0xFF667086),
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '시작일',
                                        style: TextStyle(
                                          color: Color(0xFF3E4450),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 125,
                                      ),
                                      Text(
                                        _startDate,
                                        style: TextStyle(
                                          color: Color(0xFF3E4450),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                                thickness: 0.2,
                              ),
                              SizedBox(
                                height: 50,
                                child: GestureDetector(
                                  onTap: isSelected[1]
                                      // ? () => _selectDate(context, 'end')
                                      ? () => _showCalendarModal('end')
                                      : null,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/icons/date_range.png',
                                        color: Color(0xFF667086),
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '종료일',
                                        style: TextStyle(
                                          color: Color(0xFF3E4450),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 125,
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            isSelected[0] ? '(자동)' : _endDate,
                                            style: TextStyle(
                                              color: isSelected[1]
                                                  ? Color(0xFF3E4450)
                                                  : Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isSelected[0]
                            ? SizedBox(
                                height: 35,
                                child: Row(
                                  children: [
                                    SizedBox(width: 65),
                                    Text(
                                      '종료일은 완료 버튼을 누른 기준으로\n자동 입력됩니다.',
                                      style: TextStyle(
                                        color: Color(0xFF667086),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox()
                        // TextButton(
                        //   onPressed: () {},
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       SizedBox(
                        //         width: 10,
                        //       ),
                        //       Image.asset(
                        //         'assets/icons/date_range.png',
                        //         color: Color(0xFF667086),
                        //         width: 24,
                        //         height: 24,
                        //       ),
                        //       SizedBox(
                        //         width: 15,
                        //       ),
                        //       Text(
                        //         '시작일',
                        //         style: TextStyle(
                        //             color: Color(0xFF14161A),
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w400),
                        //       ),
                        //       SizedBox(
                        //         width: 125,
                        //       ),
                        //       Text(
                        //         '0000-00-00 (월)',
                        //         style: TextStyle(
                        //             color: Color(0xFF3E4450),
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.w600),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // TextButton(
                        //   onPressed: () {},
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       SizedBox(
                        //         width: 10,
                        //       ),
                        //       Image.asset(
                        //         'assets/icons/date_range.png',
                        //         color: Color(0xFF667086),
                        //         width: 24,
                        //         height: 24,
                        //       ),
                        //       SizedBox(
                        //         width: 15,
                        //       ),
                        //       Text(
                        //         '종료일',
                        //         style: TextStyle(
                        //             color: Color(0xFF14161A),
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w400),
                        //       ),
                        //       SizedBox(
                        //         width: 125,
                        //       ),
                        //       Text(
                        //         '0000-00-00 (월)',
                        //         style: TextStyle(
                        //             color: Color(0xFF3E4450),
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.w600),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 28,
                        child: Text(
                          '기타',
                          style: TextStyle(
                            color: Color(0xFF3E4450),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 48,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        _showDescriptionModal();
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/icons/description.png',
                            color: Color(0xFF667086),
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                desc == '' ? '설명' : desc,
                                style: TextStyle(
                                  color: desc == ''
                                      ? Color(0xFF14161A)
                                      : Color(0xFF667086),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
                                // maxLines: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
