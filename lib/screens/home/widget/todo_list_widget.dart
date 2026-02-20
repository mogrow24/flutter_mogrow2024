import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/home/components/show_modal_confirm.dart';
import 'package:mogrow/screens/home/components/show_modal_move_tomorrow.dart';
import 'package:mogrow/screens/home/components/show_modal_select_goal.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoListWidget extends StatefulWidget {
  final List<Todo> todoList;
  final DateTime selectedDay;

  const TodoListWidget(
      {super.key, required this.todoList, required this.selectedDay});

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  // 체크박스 관련
  Set<int> checkedIndexes = {};

  // 날짜가 바뀌면 체크박스 초기화
  @override
  void didUpdateWidget(covariant TodoListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!isSameDay(oldWidget.selectedDay, widget.selectedDay)) {
      checkedIndexes.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.read<TodoListProvider>();

    return ListView.builder(
      // padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.todoList.length,
      itemBuilder: (context, index) {
        final todoItem = widget.todoList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(widget.todoList[index].title),
            confirmDismiss: (direction) async {
              String? deleteType = await showDialog(
                context: context,
                builder: (context) => ShowModalConfirm(
                  selectedDay: widget.selectedDay,
                  todo: todoItem,
                  type: "delete",
                ),
              );

              if (deleteType == 'repeatSelect') {
                // todoProvider.deleteRepeatSelect(todoItem, widget.selectedDay);
                return false;
              } else if (deleteType == 'repeatAll') {
                todoProvider.deleteRepeatAll(todoItem, widget.selectedDay);
                return false;
              } else if (deleteType == 'delete') {
                todoProvider.deleteTodos(todoItem.id);
                return false;
              } else {
                return false;
              }
            },
            // onDismissed: (direction) {
            //
            // },
            // 30% 이상 밀렸을 때만 onDismissed가 호출되도록 설정
            dismissThresholds: const {
              DismissDirection.endToStart: 0.5,
            },
            // 밀리는 애니메이션의 시간을 0으로 설정하여 사용자 제어
            movementDuration: Duration.zero,
            background: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Color(0xFFF04438),
                borderRadius: BorderRadius.circular(12),
              ),
              // color: Color(0xFFF04438),
              child: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: ImageIcon(
                  size: 20,
                  color: Colors.white,
                  AssetImage(
                    'assets/icons/delete.png',
                  ),
                ),
              ),
            ),
            child: Accordion(
              openAndCloseAnimation: true,
              scaleWhenAnimating: false,
              disableScrolling: true,
              paddingListBottom: 0,
              paddingListTop: 0,
              headerPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              paddingListHorizontal: 0,
              contentVerticalPadding: 3,
              contentHorizontalPadding: 1,
              paddingBetweenClosedSections: 0,
              paddingBetweenOpenSections: 0,
              headerBorderWidth: 1,
              headerBorderColor: Color(0xFFE2E2EA),
              headerBorderRadius: 12,
              contentBorderWidth: 1,
              contentBorderColor: Color(0xFFE2E2EA),
              contentBorderRadius: 12,
              children: [
                AccordionSection(
                  onCloseSection: () {
                    // print('AccodionSection Close!!');
                  },
                  // isOpen: todoItem.status,
                  isOpen: checkedIndexes.contains(index),
                  header: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // widget.provider.getTodoById(todoItem.id);
                      context.push(
                        '/updateTodo',
                        extra: {
                          'todo': todoItem,
                          'selectedDay': widget.selectedDay,
                        },
                      );
                    },
                    child: Container(
                      // width: double.infinity,
                      constraints: BoxConstraints(
                        // minHeight: 48,
                        // minWidth: double.infinity,
                        maxHeight: todoItem.repeatCode != "0" ||
                                todoItem.repeatGroupId != null
                            ? 60
                            : 48,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(
                        //   color: Color(0xFFECECF0),
                        //   width: 1,
                        // ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF101828).withOpacity(0.04),
                            spreadRadius: 0,
                            blurRadius: 2.0,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 5,
                          right: 0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Checkbox(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          value:
                                              // todoItem.status,
                                              checkedIndexes.contains(index),
                                          activeColor: Color(0xFF0066FA),
                                          splashRadius: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                checkedIndexes.add(index);
                                              } else {
                                                checkedIndexes.remove(index);
                                              }
                                            });

                                            // if (value !=
                                            //     null) {
                                            //   provider
                                            //       .updateStatus(
                                            //     todoItem.id,
                                            //     value,
                                            //   );
                                            // }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: todoItem.repeatCode ==
                                                        "0" ||
                                                    todoItem.repeatGroupId !=
                                                        null
                                                ? 0
                                                : 5,
                                          ),
                                          child: Text(
                                            todoItem.title,
                                            style: TextStyle(
                                              color: todoItem.isCompleted
                                                  ? Color(0xFFBEC4CE)
                                                  : Color(0xFF14161A),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              decoration: todoItem.isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              decorationColor:
                                                  Color(0xFFBEC4CE),
                                              decorationThickness: 2,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (todoItem.repeatCode != "0" ||
                                      todoItem.repeatGroupId != null)
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 44,
                                            right: 4,
                                          ),
                                          child: Text(
                                            '${todoItem.repeat}',
                                            style: TextStyle(
                                              color: Color(0xFF667086),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/icons/repeat.png',
                                          width: 13,
                                          height: 13,
                                          color: Color(0xFF667086),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                            SizedBox(
                              // height: 30,
                              // width: 30,
                              child: Row(
                                children: [
                                  todoItem.isContinue
                                      ? SvgPicture.asset(
                                          'assets/icons/todo/working.svg',
                                          width: 16,
                                          height: 16,
                                          color: Color(0xFF667086),
                                        )
                                      : SizedBox.shrink(),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: SvgPicture.asset(
                                      'assets/icons/gemstones/${todoItem.gemstone}.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    onPressed: () async {
                                      final result = await showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ShowModalSelectGoal(
                                            initialCheckedId: todoItem.goalId,
                                          );
                                        },
                                      );

                                      if (result != null) {
                                        Goal selectedGoal = result['goal'];

                                        todoProvider.setLoading(true);
                                        await Future.delayed(
                                            Duration(milliseconds: 400));
                                        // todo update
                                        await todoProvider.updateTodoGoal(
                                          todoItem,
                                          widget.selectedDay,
                                          selectedGoal,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  content: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                              overlayColor: Colors.transparent,
                            ),
                            icon: Icon(
                              Icons.check_outlined,
                              color: todoItem.isCompleted
                                  ? Color(0xFFBEC4CE)
                                  : Color(0xFF3E4450),
                              size: 16,
                            ),
                            label: Text(
                              '완료',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: todoItem.isCompleted
                                      ? Color(0xFFBEC4CE)
                                      : Color(0xFF3E4450)),
                            ),
                            onPressed: todoItem.isCompleted
                                ? null
                                : () {
                                    todoProvider.updateIsCompleted(
                                      todoItem,
                                      widget.selectedDay,
                                      true,
                                    );
                                    setState(() {
                                      checkedIndexes.remove(index);
                                    });
                                  },
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                              overlayColor: Colors.transparent,
                            ),
                            icon: SvgPicture.asset(
                              'assets/icons/todo/working.svg',
                              width: 16,
                              height: 16,
                              color: todoItem.isContinue
                                  ? Color(0xFFBEC4CE)
                                  : Color(0xFF3E4450),
                            ),
                            label: Text(
                              '진행 중',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: todoItem.isContinue
                                      ? Color(0xFFBEC4CE)
                                      : Color(0xFF3E4450)),
                            ),
                            onPressed: todoItem.isContinue
                                ? null
                                : () {
                                    todoProvider.updateIsContinue(
                                      todoItem,
                                      widget.selectedDay,
                                      true,
                                    );
                                    setState(() {
                                      checkedIndexes.remove(index);
                                    });
                                  },
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                              overlayColor: Colors.transparent,
                            ),
                            icon: SvgPicture.asset(
                              'assets/icons/todo/next.svg',
                              width: 16,
                              height: 16,
                              color: Color(0xFF3E4450),
                            ),
                            label: Text(
                              '내일로',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3E4450)),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => ShowModalMoveTomorrow(
                                  selectedDay: widget.selectedDay,
                                  todo: todoItem,
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                              overlayColor: Colors.transparent,
                            ),
                            icon: Icon(
                              Icons.check_outlined,
                              color:
                                  !todoItem.isContinue && !todoItem.isCompleted
                                      ? Color(0xFFBEC4CE)
                                      : Color(0xFFFCAAA4),
                              size: 16,
                            ),
                            label: Text(
                              '취소',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: !todoItem.isContinue &&
                                        !todoItem.isCompleted
                                    ? Color(0xFFBEC4CE)
                                    : Color(0xFFFCAAA4),
                              ),
                            ),
                            onPressed:
                                !todoItem.isContinue && !todoItem.isCompleted
                                    ? null
                                    : () {
                                        // widget.provider.updateIsCompleted(
                                        //   todoItem,
                                        //   widget.selectedDay,
                                        //   false,
                                        // );
                                        // widget.provider.updateIsContinue(
                                        //   todoItem.id,
                                        //   false,
                                        // );

                                        todoProvider.cancelTodo(
                                            todoItem, widget.selectedDay);
                                        setState(() {
                                          checkedIndexes.remove(index);
                                        });
                                      },
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
      },
    );
  }
}
