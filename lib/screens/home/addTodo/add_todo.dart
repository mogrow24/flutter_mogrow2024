import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momentum/screens/home/addTodo/model/goal.dart';
import 'package:momentum/widget/show_modal_select_goal.dart';
import 'package:momentum/widget/show_modal_select_repeat.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _controller = TextEditingController();
  int _characterCount = 0;
  final int _maxLength = 40;
  final int _maxLines = 3;
  final FocusNode _textFocus = FocusNode();

  // 목표 관련 상태 값
  int? selectedGoalIndex = 0;
  String? goalName = '없음';
  String? goalColor = 'core';

  // 반복 관련 상태 값
  int? selectedRepeatIndex = 0;
  String? repeatName = '반복 안함';
  String? dayText = '';

  // 삭제 관련 상태 값
  String strToday = '';

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _controller.text.length;
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('y년 M월 d일 (E)', 'ko');
    strToday = formatter.format(now);
  }

  void _showGoalSelectionModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return ShowModal(initialCheckedIndex: selectedGoalIndex);
      },
    );

    if (result != null) {
      Goal selectedGoal = result['goal'];
      int? selectedIndex = result['checkedIndex'];

      setState(() {
        selectedGoalIndex = selectedIndex;
        goalName = selectedGoal.goalName;
        goalColor = selectedGoal.goalColor;
      });
    }
  }

  void _showRepeatSelectionModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ShowModalSelectRepeat(initialCheckedIndex: selectedRepeatIndex);
      },
    );

    if (result != null) {
      setState(() {
        selectedRepeatIndex = result['checkedIndex'];
        repeatName = result['selectedRepeat'];
        dayText = result['dayText'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _textFocus.unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              context.beamBack();
            },
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.white),
            ),
            child: Image.asset(
              'assets/icons/arrow_back.png',
              width: 40,
              height: 40,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_characterCount > 0) {
                  Navigator.pop(context, {
                    'todoTitle': _controller.text,
                    'selectedGoalIndex': selectedGoalIndex,
                    'goalName': goalName,
                    'goalColor': goalColor,
                    'selectedRepeatIndex': selectedRepeatIndex,
                    'repeatName': repeatName,
                    'dayText': dayText,
                  });
                }
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.white),
              ),
              child: _characterCount < 1
                  ? Image.asset(
                      'assets/icons/check.png',
                      color: Colors.grey,
                      width: 40,
                      height: 40,
                    )
                  : Image.asset(
                      'assets/icons/check.png',
                      color: Color(0xFF0066FA),
                      width: 40,
                      height: 40,
                    ),
            ),
          ],
          title: Text(
            '새로운 할 일',
            style: TextStyle(
              color: Color(0xFF14161A),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              color: Color(0xffF6F6F8),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: TextField(
                            focusNode: _textFocus,
                            controller: _controller,
                            maxLength: _maxLength,
                            maxLines: _maxLines,
                            decoration: InputDecoration(
                              hintText: '할 일',
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
                              counterText: '$_characterCount/$_maxLength',
                              counterStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8892A6),
                              ),
                            ),
                            style: TextStyle(
                              color: Color(0xFF14161A),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (text) {
                              _updateCharacterCount();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 28,
                          child: Text(
                            '설정',
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
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextButton(
                              onPressed: () {
                                _showGoalSelectionModal();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          'assets/icons/gemstones/$goalColor.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        Text(
                                          '목표',
                                          style: TextStyle(
                                              color: Color(0xFF14161A),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '$goalName',
                                    style: TextStyle(
                                        color: Color(0xFF3E4450),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextButton(
                              onPressed: () {
                                _showRepeatSelectionModal();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/repeat.png',
                                          color: Color(0xFF667086),
                                          width: 24,
                                          height: 24,
                                        ),
                                        Text(
                                          '반복',
                                          style: TextStyle(
                                              color: Color(0xFF14161A),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '$repeatName $dayText',
                                    style: TextStyle(
                                        color: Color(0xFF3E4450),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '• $strToday에 생성됨',
                          style: TextStyle(
                            color: Color(0xFF667086),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.only(right: 5),
                              overlayColor: Colors.pinkAccent),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Image.asset(
                                  'assets/icons/delete.png',
                                  color: Color(0xFFF04438),
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                              Text(
                                '삭제',
                                style: TextStyle(
                                  color: Color(0xFFF04438),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
