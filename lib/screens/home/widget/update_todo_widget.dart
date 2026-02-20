import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/home/components/show_modal_confirm.dart';
import 'package:mogrow/screens/home/components/show_modal_select_goal.dart';
import 'package:mogrow/screens/home/components/show_modal_select_repeat.dart';
import 'package:provider/provider.dart';

class UpdateTodoWidget extends StatefulWidget {
  const UpdateTodoWidget({super.key});

  @override
  State<UpdateTodoWidget> createState() => _UpdateTodoWidgetState();
}

class _UpdateTodoWidgetState extends State<UpdateTodoWidget> {
  late TextEditingController _controller = TextEditingController();
  int _characterCount = 0;
  final int _maxLength = 40;
  final int _maxLines = 3;
  final FocusNode _textFocus = FocusNode();

  late Todo _todo;
  late DateTime _selectedDay;

  // 목표 관련 상태 값
  late Goal? _selectedGoal;
  late String _selectedGoalId;
  late String _goalTitle;
  late String _gemstone;

  // 반복 관련 상태 값
  late int _selectedRepeatIndex;
  late String _repeatName;
  String _dayText = '';

  // 삭제 관련 상태 값
  String strToday = '';

  // bool _initialized = false;

  DateFormat formatter = DateFormat('y년 M월 d일 (E)', 'ko');
  late DateTime? _createDate;

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 전달받은 데이터를 가져와서 파싱
      final data = GoRouterState.of(context).extra as Map<String, dynamic>;
      final todo = data['todo'];

      _selectedDay = data['selectedDay'];
      _todo = todo;

      Provider.of<GoalListProvider>(context, listen: false)
          .getGoalById(todo.goalId);
      _selectedGoal = context.read<GoalListProvider>().goal;

      // await Future.delayed(Duration(milliseconds: 500));

      _controller = TextEditingController(text: todo.title);
      _characterCount = _controller.text.length;
      _selectedGoalId = todo.goalId;
      _goalTitle = todo.goalTitle;
      _gemstone = todo.gemstone;
      _createDate = todo.createDate;
      _selectedRepeatIndex = int.parse(todo.repeatCode!);
      _repeatName = todo.repeat!;

      setState(() {
        _isLoading = false;
      });
    });
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _controller.text.length;
    });
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
    // print(result);
    if (result != null) {
      Goal selectedGoal = result['goal'];
      String selectedId = result['selectedId'];
      print(selectedId);

      setState(() {
        _selectedGoalId = selectedId;
        _selectedGoal = selectedGoal;
        _goalTitle = selectedGoal.title;
        _gemstone = selectedGoal.gemstone;
      });
    }
  }

  void _showRepeatSelectionModal(DateTime selectedDay) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ShowModalSelectRepeat(
          initialCheckedIndex: _selectedRepeatIndex,
          selectedDay: selectedDay,
        );
      },
    );

    if (result != null) {
      final entry = result['selectedRepeat'].entries.first;

      setState(() {
        _selectedRepeatIndex = result['checkedIndex'];
        _repeatName = entry.value; // 반복
        _dayText = result['dayText'];
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
                  final obj = {
                    'goalId': _selectedGoalId,
                    'title': _controller.text,
                    'gemstone': _gemstone,
                    'goalTitle': _goalTitle,
                    'repeat':
                        _dayText == "" ? _repeatName : '$_repeatName $_dayText',
                    'repeatCode': _selectedRepeatIndex.toString(),
                    'repeatEndDate': _selectedDay,
                    'updateDate': DateTime.now(),
                    'beforeRepeatCode': _todo.repeatCode,
                    'repeatGroupId': _todo.repeatGroupId,
                    'repeatStartDate': _todo.repeatStartDate,
                  };

                  if (_selectedGoal != null) {
                    obj['goalDiv'] = _selectedGoal!.dateDiv;
                    obj['goalStartDate'] = _selectedGoal!.startDate;
                    obj['goalEndDate'] = _selectedGoal!.endDate;
                  }

                  String? type = "";

                  type = await showDialog(
                    context: context,
                    builder: (context) => ShowModalConfirm(
                      selectedDay: _selectedDay,
                      todo: _todo,
                      type: "update",
                    ),
                  );

                  if (type == "update") {
                    final provider =
                        Provider.of<TodoListProvider>(context, listen: false);
                    provider.updateTodo(_todo.id, obj, type);

                    if (mounted) {
                      context.pop();
                    }
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
            '할 일 수정',
            style: TextStyle(
              color: Color(0xFF14161A),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3C3C3C),
                  ),
                ),
              )
            : Stack(
                children: [
                  SafeArea(
                    child: Container(
                      color: Color(0xffF6F6F8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
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
                                      counterText:
                                          '$_characterCount/$_maxLength',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextButton(
                                      onPressed: () {
                                        _textFocus.unfocus();
                                        _showGoalSelectionModal();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      fontWeight:
                                                          FontWeight.w400),
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
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextButton(
                                      onPressed: () {
                                        _textFocus.unfocus();
                                        _showRepeatSelectionModal(_selectedDay);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '$_repeatName $_dayText',
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
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '• ${formatter.format(_createDate!)}에 생성됨',
                                  style: TextStyle(
                                    color: Color(0xFF667086),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final provider =
                                        context.read<TodoListProvider>();

                                    String? deleteType = await showDialog(
                                      context: context,
                                      builder: (context) => ShowModalConfirm(
                                        selectedDay: _selectedDay,
                                        todo: _todo,
                                        type: "delete",
                                      ),
                                    );

                                    // final deleteType =
                                    //     await showDeleteModal(_todo);

                                    if (deleteType == 'repeatSelect') {
                                      // provider.deleteRepeatSelect(_todo, _selectedDay);
                                    } else if (deleteType == 'repeatAll') {
                                      provider.deleteRepeatAll(
                                          _todo, _selectedDay);
                                    } else if (deleteType == 'delete') {
                                      provider.deleteTodos(_todo.id);
                                    } else {}

                                    if (deleteType != 'cancel' && mounted) {
                                      context.pop();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.only(right: 5),
                                      overlayColor: Colors.pinkAccent),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
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
                  ),
                ],
              ),
      ),
    );
  }
}
