import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/home/components/show_modal_select_goal.dart';
import 'package:mogrow/screens/home/components/show_modal_select_repeat.dart';
import 'package:provider/provider.dart';

class AddTodoWidget extends StatefulWidget {
  const AddTodoWidget({super.key});

  @override
  State<AddTodoWidget> createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends State<AddTodoWidget> {
  final TextEditingController _controller = TextEditingController();
  int _characterCount = 0;
  final int _maxLength = 40;
  final int _maxLines = 3;
  final FocusNode _textFocus = FocusNode();

  // 목표 관련 상태 값
  String _selectedGoalId = "0000000000";
  String _goalTitle = "없음";
  String _gemstone = "core";
  DateTime? _endDate;

  // 반복 관련 상태 값
  int? selectedRepeatIndex = 0;
  String? repeatName = '반복 안함';
  String? dayText = '';

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _controller.text.length;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _showGoalSelectionModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return ShowModalSelectGoal(
          initialCheckedId: _selectedGoalId,
        );
      },
    );
    print(result);
    if (result != null) {
      Goal selectedGoal = result['goal'];
      String selectedId = result['selectedId'];

      setState(() {
        _selectedGoalId = selectedId;
        _goalTitle = selectedGoal.title;
        _gemstone = selectedGoal.gemstone;
        _endDate = selectedGoal.endDate;
      });
    }
  }

  void _showRepeatSelectionModal(DateTime selectedDay) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ShowModalSelectRepeat(
          initialCheckedIndex: selectedRepeatIndex,
          selectedDay: selectedDay,
        );
      },
    );

    if (result != null) {
      final entry = result['selectedRepeat'].entries.first;
      setState(() {
        selectedRepeatIndex = result['checkedIndex'];
        repeatName = entry.value; // 반복
        dayText = result['dayText'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context, listen: false);
    // 전달받은 데이터를 가져와서 파싱
    final data = GoRouterState.of(context).extra as Map<String, dynamic>;
    final selectedDayString = data['selectedDay'];
    final selectedDay = DateTime.parse(selectedDayString);

    return GestureDetector(
      onTap: () {
        _textFocus.unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              context.pop();
            },
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.white),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
              size: 24,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_characterCount > 0) {
                  // 아이디 생성
                  final customId = await provider.getNextCustomId(selectedDay);
                  final repeatGroupId =
                      await provider.getRepeatGroupId(selectedDay);

                  final newTodo = Todo(
                    id: customId,
                    goalId: _selectedGoalId,
                    title: _controller.text,
                    gemstone: _gemstone,
                    goalTitle: _goalTitle,
                    repeat: '$repeatName $dayText',
                    repeatCode: selectedRepeatIndex.toString(),
                    repeatGroupId:
                        selectedRepeatIndex != 0 ? repeatGroupId : null,
                    repeatStartDate:
                        selectedRepeatIndex != 0 ? selectedDay : null,
                    repeatEndDate: _endDate,
                    status: false,
                    isCompleted: false,
                    isContinue: false,
                    date: selectedDay,
                  );
                  provider.addTodo(newTodo);

                  if (mounted) {
                    context.pop();
                  }
                }
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.white),
              ),
              child: _characterCount < 1
                  ? Icon(
                      Icons.check,
                      size: 24,
                      color: Colors.grey,
                    )
                  : Icon(
                      Icons.check,
                      size: 24,
                      color: Color(0xFF0066FA),
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
                                _textFocus.unfocus();
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
                                        SvgPicture.asset(
                                          'assets/icons/gemstones/$_gemstone.svg',
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
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        _goalTitle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Color(0xFF3E4450),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextButton(
                              onPressed: () {
                                _textFocus.unfocus();
                                _showRepeatSelectionModal(selectedDay);
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
                                        Icon(
                                          Icons.repeat_rounded,
                                          size: 24,
                                          color: Color(0xFF667086),
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
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '$repeatName $dayText',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Color(0xFF3E4450),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
