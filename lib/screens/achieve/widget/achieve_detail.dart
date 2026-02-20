import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/achieve/components/achieve_detail_orderby.dart';
import 'package:mogrow/screens/achieve/components/achieve_grid_view.dart';
import 'package:mogrow/screens/achieve/components/achieve_list_view.dart';
import 'package:mogrow/screens/achieve/components/scrollable_calendar_view.dart';
import 'package:mogrow/screens/achieve/components/show_modal_delete.dart';
import 'package:mogrow/screens/achieve/widget/goal_update.dart';
import 'package:mogrow/screens/layout/main_screen.dart';
import 'package:provider/provider.dart';

class AchieveDetail extends StatefulWidget {
  const AchieveDetail({super.key});

  @override
  State<AchieveDetail> createState() => _AchieveDetailState();
}

class _AchieveDetailState extends State<AchieveDetail> {
  late TextEditingController _controller = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  bool _isLoading = true;

  // 현재 월
  final ValueNotifier<int> currentMonthNotifier =
      ValueNotifier<int>(DateTime.now().month);

  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 넘겨 받은 데이터
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
      final goalId = extra['goalId'];

      context.read<RecordListProvider>().getRecordListByGoalId(goalId);

      final goalProvider =
          Provider.of<GoalListProvider>(context, listen: false);
      await goalProvider.getGoalById(goalId);

      _controller = TextEditingController(text: goalProvider.goal?.reason);

      setState(() {
        _isLoading = false; // 로딩 완료
      });
    });
  }

  @override
  void dispose() {
    _textFocus.dispose(); // FocusNode 해제
    _controller.dispose(); // Controller 해제
    super.dispose();
  }

  // 정렬 모달
  // int? selectedArrangeIndex = 0;
  int? selectedArrangeIndex1 = 0;
  int? selectedArrangeIndex2 = 1;
  void showOrderByModal() async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AchieveDetailOrderby(
            initialCheckedIndex: selectedArrangeIndex1,
            initialCheckedIndex1: selectedArrangeIndex2,
          );
        });

    if (result != null) {
      setState(() {
        selectedArrangeIndex1 = result['checkedIndex'];
        selectedArrangeIndex2 = result['checkedIndex1'];
      });
    }
  }

  // 달력, 리스트 뷰 토글 버튼
  // List<bool> isSelected = [true, false];
  // void _toggleButton(int index) {
  //   if (isSelected[index]) {
  //     // 이미 선택된 버튼을 다시 클릭할 때는 아무 동작도 하지 않음
  //     return;
  //   }
  //   setState(() {
  //     isSelected[0] = index == 0;
  //     isSelected[1] = index == 1;
  //   });
  // }

  // 목표 설명란 토글 버튼
  bool isToggle = false;
  void _descToggleButton() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  // 목표 설명란
  bool _isEditing = true;
  Widget achieveDesc(String id) {
    return Padding(
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
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: TextField(
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
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
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
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Color(0xFF8892A6),
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      String reason = _controller.text;
                      context.read<GoalListProvider>().updateReason(id, reason);

                      setState(() {
                        _isEditing = true;
                      });
                    },
                    icon: Icon(
                      Icons.check,
                      size: 20,
                      color: Color(0xFF6046FF),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 넘겨 받은 데이터
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final goalId = extra['goalId'];

    final goal = context.watch<GoalListProvider>().goal;
    final recordList = context.watch<RecordListProvider>().recordList;
    final processedRecordData =
        context.watch<RecordListProvider>().processedRecordData;

    Map<DateTime, bool> recordHasDataMap = {};
    for (var item in recordList) {
      final date = item.date;
      final normalizedDate = DateTime(date.year, date.month, date.day);

      recordHasDataMap[normalizedDate] = true;
    }

    final todoList =
        context.read<TodoListProvider>().getListByGoalIdAll(goalId);
    // 목표에 대한 할일 리스트 -> 해당 되는 날짜만 추출
    Map<DateTime, List<Todo>> dateTodoList =
        context.read<TodoListProvider>().groupTodosByDate(todoList);
    Map<DateTime, bool> dateHasDataMap = {
      for (var date in dateTodoList.keys)
        date: dateTodoList[date]?.isNotEmpty ?? false,
    };

    if (goal == null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3C3C3C),
          ),
        ),
      );
    }

    // 디데이
    String dDay;
    if (goal.dateDiv == "1") {
      dDay = goal.startDate != null
          ? 'D+${-goal.startDate!.difference(DateTime.now()).inDays + 1}'
          : '';
    } else {
      dDay = goal.startDate != null
          ? 'D-${-goal.startDate!.difference(goal.endDate!).inDays}'
          : '';
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFFECECF0),
            width: 1,
          ),
        ),
        leading: TextButton(
          onPressed: () {
            context.pop();
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              position: PopupMenuPosition.under,
              color: Color(0xFFFFFFFF),
              constraints: const BoxConstraints(
                minWidth: 130,
                maxWidth: 130,
                maxHeight: 160,
              ),

              /// 팝업 메뉴의 테두리와 round 처리
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                // 메뉴 아이템 클릭 시 동작
                if (value == 'U') {
                  // 수정하기
                  Navigator.of(context).push(_FullScreenPageRoute(goal));
                } else if (value == 'D') {
                  // 삭제하기 (기타 목표는 삭제 불가)
                  final idToDelete =
                      goalId is String ? goalId : goalId?.toString();
                  if (idToDelete == null ||
                      idToDelete.isEmpty ||
                      idToDelete == '0000000000') {
                    return;
                  }

                  final currentContext = context;

                  String? deleteType = await showDialog(
                    context: currentContext,
                    builder: (context) => ShowModalDelete(),
                  );

                  if (mounted) {
                    if (deleteType == 'delete') {
                      try {
                        await currentContext
                            .read<GoalListProvider>()
                            .deleteGoals(idToDelete);

                        // 삭제 후 할일, 기록 다시 호출
                        await currentContext
                            .read<TodoListProvider>()
                            .fetchTodos();
                        await currentContext
                            .read<RecordListProvider>()
                            .fetchRecords();

                        if (currentContext.mounted) {
                          currentContext.pop();
                        }
                      } catch (e, stack) {
                        debugPrint('목표 삭제 실패: $e');
                        debugPrint('$stack');
                      }
                    }
                  }
                } else if (value == 'C') {
                  // 완료하기
                  context
                      .read<GoalListProvider>()
                      .updateCompleted(goalId, true);
                } else if (value == 'N') {
                  // 미완료하기
                  context
                      .read<GoalListProvider>()
                      .updateCompleted(goalId, false);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'U',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Image.asset(
                      //   'assets/icons/edit.png',
                      //   color: Color(0xFF667086),
                      //   width: 24,
                      //   height: 24,
                      // ),
                      Icon(
                        Icons.edit_outlined,
                        size: 24,
                        color: Color(0xFF667086),
                      ),
                      Text(
                        '수정하기',
                        style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'D',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.delete_outlined,
                        size: 24,
                        color: Color(0xFF667086),
                      ),
                      Text(
                        '삭제하기',
                        style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: goal.isCompleted ? 'N' : 'C',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        size: 24,
                        color: Color(0xFF667086),
                      ),
                      Text(
                        goal.isCompleted ? '미완료하기' : '완료하기',
                        style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Text(
          goal.title,
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
              color: Color(0xffF6F6F8),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6046FF),
                ),
              ),
            )
          : SafeArea(
              child: Container(
                color: Color(0xffF6F6F8),
                child: Column(
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
                              SvgPicture.asset(
                                'assets/icons/gemstones/${goal.gemstone}.svg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                // filterQuality: FilterQuality.high,
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
                            onPressed: () {
                              _descToggleButton();
                            },
                            icon: Icon(
                              Icons.notes,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                          // isSelected[1]
                          //     ? IconButton(
                          //         onPressed: () {
                          //           showOrderByModal();
                          //         },
                          //         icon: Icon(
                          //           Icons.sort,
                          //           size: 24,
                          //           color: Colors.black,
                          //         ),
                          //       )
                          //     : SizedBox.shrink()
                        ],
                      ),
                    ),
                    isToggle ? achieveDesc(goalId) : SizedBox.shrink(),
                    recordList.isEmpty && todoList.isEmpty
                        ? Flexible(
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '아직 한 일이 없어요',
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
                                      // context.pop();
                                      MainScreen.changeTab(context, 0);
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
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
                            ),
                          )
                        : recordList.isEmpty && todoList.isNotEmpty
                            ? Flexible(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '아직 기록이 없어요',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF8892A6),
                                        ),
                                      ),
                                      Text(
                                        '한 일에 대한 기록을 적어보세요',
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
                                          MainScreen.changeTab(context, 1);
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
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
                                            '기록 적으러 가기',
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
                                ),
                              )
                            : Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "나의 기록을 확인해 보세요.",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  context.push(
                                                    '/recordSearch',
                                                    extra: {
                                                      'goal': goal,
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.search,
                                                  size: 18,
                                                  color: Color(0xFF667086),
                                                ),
                                                padding: EdgeInsets.zero,
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      WidgetStateProperty.all<
                                                              Color>(
                                                          Colors.transparent),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showOrderByModal();
                                                },
                                                icon: Icon(
                                                  Icons.sort,
                                                  size: 18,
                                                  color: Color(0xFF667086),
                                                ),
                                                padding: EdgeInsets.zero,
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      WidgetStateProperty.all<
                                                              Color>(
                                                          Colors.transparent),
                                                ),
                                              ),
                                              // isSelected[0]
                                              //     ? IconButton(
                                              //         onPressed: () {
                                              //           _toggleButton(1);
                                              //         },
                                              //         icon: Icon(
                                              //           Icons.sort,
                                              //           size: 18,
                                              //           color: Color(0xFF667086),
                                              //         ),
                                              //         padding: EdgeInsets.zero,
                                              //         style: ButtonStyle(
                                              //           overlayColor: WidgetStateProperty
                                              //               .all<Color>(
                                              //                   Colors.transparent),
                                              //         ),
                                              //       )
                                              //     : IconButton(
                                              //         onPressed: () {
                                              //           _toggleButton(0);
                                              //         },
                                              //         icon: Icon(
                                              //           Icons.calendar_month_outlined,
                                              //           size: 18,
                                              //           color: Color(0xFF667086),
                                              //         ),
                                              //         padding: EdgeInsets.zero,
                                              //         style: ButtonStyle(
                                              //           overlayColor: WidgetStateProperty
                                              //               .all<Color>(
                                              //                   Colors.transparent),
                                              //         ),
                                              //       ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    selectedArrangeIndex2 == 0
                                        ? AchieveListView(
                                            goal: goal,
                                            list: processedRecordData,
                                            orderby: selectedArrangeIndex1)
                                        : selectedArrangeIndex2 == 1
                                            ? ScrollableCalendarView(
                                                goal: goal,
                                                recordHasDataMap:
                                                    recordHasDataMap,
                                                dateHasDataMap: dateHasDataMap,
                                              )
                                            : AchieveGridView(
                                                goal: goal,
                                                list: processedRecordData,
                                                orderby: selectedArrangeIndex1)
                                    // isSelected[0]
                                    //     ? ScrollableCalendarView(
                                    //         goal: goal,
                                    //         recordList: recordList,
                                    //       )
                                    //     : selectedArrangeIndex2 == 0
                                    //         ? AchieveListView(list: tempGridList)
                                    //         : selectedArrangeIndex2 == 1
                                    //             ? ScrollableCalendarView(
                                    //                 goal: goal,
                                    //                 recordList: recordList,
                                    //               )
                                    //             : AchieveGridView(
                                    //                 list: tempGridList,
                                    //               )
                                  ],
                                ),
                              ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _FullScreenPageRoute extends PageRouteBuilder {
  _FullScreenPageRoute(Goal goal)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return GoalUpdate(goal: goal);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}
