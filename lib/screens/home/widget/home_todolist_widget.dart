import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:mogrow/screens/home/widget/add_todolist_widget.dart';
import 'package:mogrow/widget/show_modal_add_goal.dart';
import 'package:mogrow/widget/show_modal_select_goal.dart';

class HomeTodolistWidget extends StatefulWidget {
  final List<Map<String, dynamic>> todoList;

  const HomeTodolistWidget({super.key, required this.todoList});

  @override
  State<HomeTodolistWidget> createState() => _HomeTodolistWidgetState();
}

class _HomeTodolistWidgetState extends State<HomeTodolistWidget> {
  // final List<String> todoList = [
  //   '보석 아이콘 제작',
  //   '엣지 케이스 그리기',
  //   '디자인에 플로우 적용 후 놓친 것 다시 하기',
  //   '디자인 시스템 구축',
  // ];

  // 목표 관련
  int? selectedGoalIndex = 0;

  // 내일로 관련
  String formattedTomorrow = DateFormat('M월 d일', 'ko_KR')
      .format(DateTime.now().add(Duration(days: 1)));

  // 정렬 모달
  int? selectedArrangeIndex = 0;
  void showOrderByModal() async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShowModalOrderby(initialCheckedIndex: selectedArrangeIndex);
        });

    if (result != null) {
      setState(() {
        selectedArrangeIndex = result['checkedIndex'];
      });
    }
  }

  // 삭제 모달
  Future<bool?> showDeleteModal() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 170,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      '할 일을 삭제할까요?',
                      style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(child: Text('삭제됩니다.')),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // 취소
                          },
                          child: Text(
                            '취소',
                            style: TextStyle(
                              color: Color(0xFF0066FA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // 확인
                          },
                          child: Text(
                            '삭제',
                            style: TextStyle(
                              color: Color(0xFF0066FA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// 내일로 모달
  Future<bool?> showMoveTomorrowModal() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 170,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      '내일로 미룰까요?',
                      style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(child: Text('$formattedTomorrow 일정으로 이동합니다.')),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // 취소
                          },
                          child: Text(
                            '취소',
                            style: TextStyle(
                              color: Color(0xFF0066FA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // 확인
                          },
                          child: Text(
                            '확인',
                            style: TextStyle(
                              color: Color(0xFF0066FA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color(0xffF6F6F8),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '나의 오늘',
                      style: TextStyle(
                        color: Color(0xff3E4450),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showOrderByModal();
                      },
                      style: ButtonStyle(),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.sort,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '정렬',
                              style: TextStyle(
                                color: Color(0xff3E4450),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                // color: Color(0xFFFFFFFF),
                child: widget.todoList.isEmpty
                    ? Center(
                        child: Text(
                          '아직 할 일이 없어요.',
                          style: TextStyle(
                            color: Color(0xFF8892A6),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : ListView.builder(
                        // padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: widget.todoList.length,
                        itemBuilder: (context, index) {
                          final todoItem = widget.todoList[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              key: Key(todoItem['title']),
                              confirmDismiss: (direction) async {
                                return await showDeleteModal();
                              },
                              onDismissed: (direction) {
                                setState(() {
                                  widget.todoList.removeAt(index); // 리스트에서 삭제
                                });
                              },
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
                                headerPadding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
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
                                      print('close');
                                    },
                                    header: Container(
                                      // width: double.infinity,
                                      constraints: BoxConstraints(
                                        // minHeight: 48,
                                        // minWidth: double.infinity,
                                        maxHeight: todoItem['repeat'] != null
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
                                            color: Color(0xFF101828)
                                                .withOpacity(0.04),
                                            spreadRadius: 0,
                                            blurRadius: 2.0,
                                            offset: Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 30,
                                                        child: Checkbox(
                                                          value: todoItem[
                                                              'status'],
                                                          activeColor:
                                                              Color(0xFF0066FA),
                                                          splashRadius: 24,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              todoItem[
                                                                      'status'] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          todoItem['title'],
                                                          style: TextStyle(
                                                            color: todoItem[
                                                                    'isCompleted']
                                                                ? Color(
                                                                    0xFFBEC4CE)
                                                                : Color(
                                                                    0xFF14161A),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16,
                                                            decoration: todoItem[
                                                                    'isCompleted']
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                            decorationColor:
                                                                Color(
                                                                    0xFFBEC4CE),
                                                            decorationThickness:
                                                                2,
                                                          ),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (todoItem['repeat'] !=
                                                      null)
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                        ),
                                                        Text(
                                                          todoItem['repeat'],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF667086),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Image.asset(
                                                          'assets/icons/repeat.png',
                                                          width: 14,
                                                          height: 14,
                                                          color:
                                                              Color(0xFF667086),
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
                                                  todoItem['isContinue']
                                                      ? Image.asset(
                                                          'assets/icons/todo/working.png',
                                                          width: 18,
                                                          height: 18,
                                                          color:
                                                              Color(0xFF667086),
                                                        )
                                                      : SizedBox.shrink(),
                                                  IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: Image.asset(
                                                      'assets/icons/gemstones/${todoItem['gemstone']}.png',
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                    onPressed: () async {
                                                      final result =
                                                          await showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ShowModal(
                                                            initialCheckedIndex:
                                                                todoItem[
                                                                        'selectedGoalIndex'] ??
                                                                    0,
                                                          );
                                                        },
                                                      );

                                                      if (result != null) {
                                                        Goal selectedGoal =
                                                            result['goal'];

                                                        setState(() {
                                                          todoItem['title'] =
                                                              selectedGoal
                                                                  .goalName;
                                                          todoItem['gemstone'] =
                                                              selectedGoal
                                                                  .goalColor;
                                                          todoItem[
                                                                  'selectedGoalIndex'] =
                                                              result[
                                                                  'checkedIndex'];
                                                        });
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
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          icon: Image.asset(
                                            'assets/icons/check.png',
                                            width: 16,
                                            height: 16,
                                          ),
                                          label: Text(
                                            '완료',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF3E4450)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              // 완료 상태 변경
                                              todoItem['isCompleted'] = true;
                                            });
                                          },
                                        ),
                                        TextButton.icon(
                                          icon: Image.asset(
                                            'assets/icons/todo/working.png',
                                            width: 16,
                                            height: 16,
                                          ),
                                          label: Text(
                                            '진행 중',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF3E4450)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              todoItem['isContinue'] = true;
                                            });
                                          },
                                        ),
                                        TextButton.icon(
                                          icon: Image.asset(
                                            'assets/icons/todo/next.png',
                                            width: 16,
                                            height: 16,
                                          ),
                                          label: Text(
                                            '내일로',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF3E4450)),
                                          ),
                                          onPressed: () {
                                            showMoveTomorrowModal();
                                          },
                                        ),
                                        TextButton.icon(
                                          icon: Image.asset(
                                            'assets/icons/check.png',
                                            width: 16,
                                            height: 16,
                                            color: Color(0xFFFCAAA4),
                                          ),
                                          label: Text(
                                            '취소',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFFCAAA4),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              todoItem['isCompleted'] = false;
                                              todoItem['isContinue'] = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
