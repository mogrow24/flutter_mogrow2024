import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/layout/main_screen.dart';
import 'package:mogrow/screens/record/components/orderby_modal.dart';
import 'package:provider/provider.dart';

class RecordListWidget extends StatefulWidget {
  final DateTime selectedDay;

  const RecordListWidget({
    super.key,
    required this.selectedDay,
  });

  @override
  State<RecordListWidget> createState() => _RecordListWidgetState();
}

class _RecordListWidgetState extends State<RecordListWidget> {
  // 정렬 기준이 되는 색상 순서
  final List<String> _gemstoneOrder = [
    'core',
    'ruby',
    'sunstone',
    'citrine',
    'sphene',
    'emerald',
    'aquamarine',
    'sapphire',
    'tanzanite',
    'amethyst',
    'rose-quartz',
    'smoky-quartz',
  ];

  // 정렬 모달
  int? selectedArrangeIndex = 0;
  void showOrderByModal() async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return OrderbyModal(initialCheckedIndex: selectedArrangeIndex);
        });

    if (result != null) {
      setState(() {
        selectedArrangeIndex = result['checkedIndex'];
      });
    }
  }

  // 목표 리스트 정렬 함수
  void _sortGoalList(List<Goal> goalList, int? arrangeIndex) {
    if (arrangeIndex == null) return;

    goalList.sort((a, b) {
      if (arrangeIndex == 0) {
        // 0: 만든 날짜순 (최신 순 = 내림차순)
        if (a.createDate != null && b.createDate != null) {
          // b가 a보다 최신이면 1을 반환하여 b를 앞으로 보냅니다.
          return b.createDate!.compareTo(a.createDate!);
        }
        return 0;
      } else if (arrangeIndex == 1) {
        // 1: 제목 가나다 순 (내림차순)
        return b.title.compareTo(a.title);
      } else if (arrangeIndex == 2) {
        // 2: 색상 순 (정해진 _gemstoneOrder 순서)
        final aIndex = _gemstoneOrder.indexOf(a.gemstone);
        final bIndex = _gemstoneOrder.indexOf(b.gemstone);

        // 정렬 리스트에 없는 항목은 -1로 처리되므로, 있는 항목이 앞으로 오도록 처리 (선택 사항)
        if (aIndex == -1 && bIndex == -1) return 0;
        if (aIndex == -1) return 1; // a가 없으면 b가 앞으로
        if (bIndex == -1) return -1; // b가 없으면 a가 앞으로

        // 정해진 순서(오름차순)대로 정렬
        return aIndex.compareTo(bIndex);
      }
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final goalList = context.watch<GoalListProvider>().goalList;
    final provider = Provider.of<GoalListProvider>(context);
    final recordProvider = Provider.of<RecordListProvider>(context);
    final todoProvider = Provider.of<TodoListProvider>(context);
    final allRecordList = recordProvider.allRecordList;

    final bool status = provider.goalList.any((goalItem) {
      final todoListCnt =
          todoProvider.getListCntByGoalId(goalItem.goalId, widget.selectedDay);
      return todoListCnt >= 1;
    });

    // 현재는 이 위젯 내에서 정렬을 적용하기 위해 사본을 만들어 정렬하겠습니다.
    final List<Goal> displayGoalList = List.of(provider.goalList);

    // 획득한 사본을 현재 선택된 정렬 기준으로 정렬합니다.
    _sortGoalList(displayGoalList, selectedArrangeIndex);

    return Expanded(
      child: Container(
        color: Color(0xffF6F6F8),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 0,
            bottom: 0,
          ),
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
                      '오늘 진행한 목표',
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
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
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
                child: !status
                    ? Align(
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
                                MainScreen.changeTab(context, 0);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Color(0xFF6046FF)),
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
                        itemCount: displayGoalList.length,
                        itemBuilder: (context, index) {
                          final goalItem = displayGoalList[index];

                          final todoListCnt = todoProvider.getListCntByGoalId(
                              goalItem.goalId, widget.selectedDay);
                          final completedCnt = todoProvider.getCompleltedCnt(
                              goalItem.goalId, widget.selectedDay);

                          final record = allRecordList.firstWhereOrNull(
                              (item) =>
                                  item.goalId == goalItem.goalId &&
                                  item.date == widget.selectedDay);

                          if (todoListCnt < 1) {
                            return SizedBox.shrink();
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            child: Container(
                              height: 64,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              constraints: BoxConstraints(
                                  // minHeight: 48,
                                  // minWidth: double.infinity,
                                  ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFE2E2EA),
                                  width: 1,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: SvgPicture.asset(
                                          'assets/icons/gemstones/${goalItem.gemstone}.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              goalItem.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Color(0xFF14161A),
                                              ),
                                            ),
                                            Text(
                                              "완료한 일 $completedCnt/$todoListCnt",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Color(0xFF667086),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  record != null
                                      ? IconButton(
                                          padding: EdgeInsets.all(10),
                                          onPressed: () {
                                            context.push(
                                              '/recordSurveyDetail',
                                              extra: {
                                                'gemstone': goalItem.gemstone,
                                                'title': goalItem.title,
                                                'selectedDay':
                                                    widget.selectedDay,
                                                'goalId': goalItem.goalId,
                                              },
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/my-mood/${record.surveyMood}.svg',
                                            color: Colors.black,
                                            height: 22,
                                            width: 22,
                                          ),
                                          style: ButtonStyle(
                                            // backgroundColor: WidgetStateProperty.all(
                                            //   Color(0xFFECEEFF),
                                            // ),
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        )
                                      : IconButton(
                                          padding: EdgeInsets.all(10),
                                          onPressed: () {
                                            context.push(
                                              '/recordSurvey',
                                              extra: {
                                                'gemstone': goalItem.gemstone,
                                                'title': goalItem.title,
                                                'selectedDay':
                                                    widget.selectedDay,
                                                'goalId': goalItem.goalId,
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: Color(0xFF6046FF),
                                            size: 20,
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                              Color(0xFFECEEFF),
                                            ),
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                  // ElevatedButton(
                                  //   onPressed: () {},
                                  //   child: Icon(
                                  //     Icons.edit_outlined,
                                  //     color: Color(0xFF6046FF),
                                  //   ),
                                  // )
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
