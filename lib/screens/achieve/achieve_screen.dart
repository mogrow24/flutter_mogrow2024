import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/achieve_list.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/screens/achieve/components/orderby_modal.dart';
import 'package:mogrow/screens/home/components/show_modal_new_goal.dart';
import 'package:provider/provider.dart';

class AchieveScreen extends StatefulWidget {
  const AchieveScreen({super.key});

  @override
  State<AchieveScreen> createState() => _AchieveScreenState();
}

class _AchieveScreenState extends State<AchieveScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  // 앱 다운 날짜 (시작날짜)
  String? _formattedStartDate;
  String? _formattedDday;

  // 오늘 다짐 Text
  bool _isEditing = true;

  @override
  void dispose() {
    _textFocus.dispose(); // FocusNode 해제
    _controller.dispose(); // Controller 해제
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 최초 실행 시 앱 설치 날짜 저장
      final achieveProvider =
          Provider.of<AchieveListProvider>(context, listen: false);
      await achieveProvider.insertInstallDate();
      await achieveProvider.getInstallDate();

      DateTime? installDate = achieveProvider.installDate;

      if (installDate != null) {
        print('앱 설치 날짜: $installDate');
        setState(() {
          _formattedStartDate = DateFormat('yyyy.MM.dd').format(installDate);
          final diff = installDate.difference(DateTime.now());
          _formattedDday = '${-diff.inDays + 1}';
        });
      } else {
        print('설치 날짜를 찾을 수 없습니다.');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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

  @override
  Widget build(BuildContext context) {
    final goalList = context.watch<GoalListProvider>().goalList;
    final completedCnt = context.watch<GoalListProvider>().completedCnt;

    final completedList = goalList.where((ele) => ele.isCompleted).toList();
    final notCompletedList = goalList.where((ele) => !ele.isCompleted).toList();

    // D-Day 카운트를 계산하는 헬퍼 함수
    int calculateDDayCount(Goal goalItem) {
      if (goalItem.startDate == null) return 0;

      if (goalItem.dateDiv == "1") {
        // D+ 카운트: 'D+${-goalItem.startDate!.difference(DateTime.now()).inDays + 1}'
        // 시작일로부터 오늘까지의 날짜 차이 + 1
        return -goalItem.startDate!.difference(DateTime.now()).inDays + 1;
      } else if (goalItem.dateDiv == "2" && goalItem.endDate != null) {
        // D- 카운트: 'D-${-goalItem.startDate!.difference(goalItem.endDate!).inDays}'
        // (종료일 - 시작일) 차이 = 남은 일수 (절대값)
        return -goalItem.startDate!.difference(goalItem.endDate!).inDays;
      }
      return 0;
    }

    // 1. notCompletedList 정렬
    notCompletedList.sort((a, b) {
      if (selectedArrangeIndex == 0) {
        // D+ 진행순 정렬: D+가 D-보다 우선, 카운팅 수 많은 순 (내림차순)
        bool isaDplus = a.dateDiv == "1";
        bool isbDplus = b.dateDiv == "1";

        // 1. D+ 우선순위 (D+가 위, D-가 아래)
        if (isaDplus != isbDplus) {
          return isbDplus ? 1 : -1; // B가 D+면 B를 앞으로(1), A가 D+면 A를 앞으로(-1)
        }

        // 2. 카운팅 수 비교 (내림차순: 많은 순)
        final int aCount = calculateDDayCount(a);
        final int bCount = calculateDDayCount(b);
        return bCount.compareTo(aCount);
      } else if (selectedArrangeIndex == 1) {
        // D- 완료순 정렬: D-가 D+보다 우선, 카운팅 수 많은 순 (내림차순)
        bool isaDminus = a.dateDiv == "2";
        bool isbDminus = b.dateDiv == "2";

        // 1. D- 우선순위 (D-가 위, D+가 아래)
        if (isaDminus != isbDminus) {
          return isbDminus ? 1 : -1; // B가 D-면 B를 앞으로(1), A가 D-면 A를 앞으로(-1)
        }

        // 2. 카운팅 수 비교 (내림차순: 많은 순)
        final int aCount = calculateDDayCount(a);
        final int bCount = calculateDDayCount(b);
        return bCount.compareTo(aCount);
      } else if (selectedArrangeIndex == 2) {
        // 만든 날짜순 정렬 (최신 순)
        if (a.createDate != null && b.createDate != null) {
          return b.createDate!.compareTo(a.createDate!); // 최신 순 (내림차순)
        }
        return 0;
      }
      return 0;
    });

    completedList.sort((a, b) {
      if (selectedArrangeIndex == 0) {
        // D+ 진행순 정렬: D+가 D-보다 우선, 카운팅 수 많은 순 (내림차순)
        bool isaDplus = a.dateDiv == "1";
        bool isbDplus = b.dateDiv == "1";

        // 1. D+ 우선순위 (D+가 위, D-가 아래)
        if (isaDplus != isbDplus) {
          return isbDplus ? 1 : -1; // B가 D+면 B를 앞으로(1), A가 D+면 A를 앞으로(-1)
        }

        // 2. 카운팅 수 비교 (내림차순: 많은 순)
        final int aCount = calculateDDayCount(a);
        final int bCount = calculateDDayCount(b);
        return bCount.compareTo(aCount);
      } else if (selectedArrangeIndex == 1) {
        // D- 완료순 정렬: D-가 D+보다 우선, 카운팅 수 많은 순 (내림차순)
        bool isaDminus = a.dateDiv == "2";
        bool isbDminus = b.dateDiv == "2";

        // 1. D- 우선순위 (D-가 위, D+가 아래)
        if (isaDminus != isbDminus) {
          return isbDminus ? 1 : -1; // B가 D-면 B를 앞으로(1), A가 D-면 A를 앞으로(-1)
        }

        // 2. 카운팅 수 비교 (내림차순: 많은 순)
        final int aCount = calculateDDayCount(a);
        final int bCount = calculateDDayCount(b);
        return bCount.compareTo(aCount);
      } else if (selectedArrangeIndex == 2) {
        // 만든 날짜순 정렬 (최신 순)
        if (a.createDate != null && b.createDate != null) {
          return b.createDate!.compareTo(a.createDate!); // 최신 순 (내림차순)
        }
        return 0;
      }
      return 0;
    });

    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Container(
                height: 140,
                // color: Color(0xFFFFFFFF),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffECECF0),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'D + $_formattedDday',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF14161A),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            children: [
                              Text(
                                '$_formattedStartDate ~ ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF3E4450),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 4,
                            ),
                            child: Image.asset(
                              'assets/icons/achieve/line.png',
                              width: 14,
                              height: 14,
                              color: Color(0xFF6046FF),
                            ),
                          ),
                          Text('$completedCnt 개의 달성'),
                          SizedBox(
                            width: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 4,
                            ),
                            child: Image.asset(
                              'assets/icons/record/fill.png',
                              width: 14,
                              height: 14,
                              color: Color(0xFF6046FF),
                            ),
                          ),
                          Text(
                              '${context.watch<RecordListProvider>().recordAllcnt} 개의 기록'),
                        ],
                      ),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      Row(
                        children: [
                          Expanded(
                              child: !_isEditing
                                  ? TextField(
                                      focusNode: _textFocus,
                                      controller: _controller,
                                      // readOnly: _isReadOnly,
                                      maxLines: 1,
                                      maxLength: 25,
                                      decoration: InputDecoration(
                                        hintText: '오늘의 나의 다짐을 적어보세요.',
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF8892A6),
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
                                          ? '오늘의 나의 다짐을 적어보세요.'
                                          : _controller.text,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: _controller.text.isEmpty
                                              ? Color(0xFF8892A6)
                                              : Color(0xFF14161A)),
                                    )),
                          _isEditing
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                    });
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      FocusScope.of(context)
                                          .requestFocus(_textFocus);
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
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.check_outlined,
                                    color: Color(0xFF6046FF),
                                    size: 16,
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  color: Color(0xffF6F6F8),
                  child: goalList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '아직 목표가 없어요',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF8892A6),
                                ),
                              ),
                              Text(
                                '목표를 만들어 보세요',
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
                                  Navigator.of(context)
                                      .push(_FullScreenPageRoute());
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
                                    '목표 만들러 가기',
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '나의 목표',
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
                                child: ListView.builder(
                                    itemCount: completedList.length +
                                        notCompletedList.length +
                                        1,
                                    itemBuilder: (context, index) {
                                      if (index == notCompletedList.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            top: 20,
                                            bottom: 5,
                                          ),
                                          child: Text(
                                            '달성한 목표',
                                            style: TextStyle(
                                              color: Color(0xFF8892A6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        );
                                      } else {
                                        if (index < notCompletedList.length) {
                                          Goal goalItem =
                                              notCompletedList[index];
                                          String dDay;

                                          if (goalItem.dateDiv == "1") {
                                            dDay = goalItem.startDate != null
                                                ? 'D+${-goalItem.startDate!.difference(DateTime.now()).inDays + 1}'
                                                : '';
                                          } else {
                                            dDay = goalItem.startDate != null
                                                ? 'D-${-goalItem.startDate!.difference(goalItem.endDate!).inDays}'
                                                : '';
                                          }

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 5,
                                            ),
                                            child: Container(
                                              height: 64,
                                              // padding: EdgeInsets.symmetric(
                                              //     horizontal: 12),
                                              constraints: BoxConstraints(
                                                  // minHeight: 48,
                                                  // minWidth: double.infinity,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Color(0xFFE2E2EA),
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xFF101828)
                                                        .withOpacity(0.04),
                                                    spreadRadius: 0,
                                                    blurRadius: 2.0,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                onPressed: () {
                                                  // print(GoRouter.of(context)
                                                  //     .routerDelegate
                                                  //     .currentConfiguration
                                                  //     .last);
                                                  context.push(
                                                    '/achieveDetail',
                                                    extra: {
                                                      'goalId': goalItem.goalId,
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/gemstones/${goalItem.gemstone}.svg',
                                                            width: 24,
                                                            height: 24,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                goalItem.title,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xFF14161A),
                                                                ),
                                                              ),
                                                              goalItem.startDate ==
                                                                      null
                                                                  ? SizedBox
                                                                      .shrink()
                                                                  : Text(
                                                                      goalItem.dateDiv ==
                                                                              "1"
                                                                          ? '${goalItem.startDate.toString().split(" ")[0].replaceAll("-", ".")} ~ '
                                                                          : '${goalItem.startDate.toString().split(" ")[0].replaceAll("-", ".")} ~ ${goalItem.endDate.toString().split(" ")[0].replaceAll("-", ".")}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF667086),
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Text(
                                                        dDay,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          int idx = index -
                                              notCompletedList.length -
                                              1;
                                          Goal goalItem = completedList[idx];
                                          String dDay;

                                          if (goalItem.dateDiv == "1") {
                                            dDay = goalItem.startDate != null
                                                ? 'D+${-goalItem.startDate!.difference(DateTime.now()).inDays}'
                                                : '';
                                          } else {
                                            dDay = goalItem.startDate != null
                                                ? 'D-${-goalItem.startDate!.difference(goalItem.endDate!).inDays}'
                                                : '';
                                          }

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 5,
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 64,
                                              constraints: BoxConstraints(
                                                  // minHeight: 48,
                                                  // minWidth: double.infinity,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Color(0xFFE2E2EA),
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xFF101828)
                                                        .withOpacity(0.04),
                                                    spreadRadius: 0,
                                                    blurRadius: 2.0,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                onPressed: () {
                                                  context.push(
                                                    '/achieveDetail',
                                                    extra: {
                                                      'goalId': goalItem.goalId,
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/gemstones/${goalItem.gemstone}.svg',
                                                            width: 24,
                                                            height: 24,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                goalItem.title,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xFF14161A),
                                                                ),
                                                              ),
                                                              goalItem.startDate ==
                                                                      null
                                                                  ? SizedBox
                                                                      .shrink()
                                                                  : Text(
                                                                      goalItem.dateDiv ==
                                                                              "1"
                                                                          ? '${goalItem.startDate.toString().split(" ")[0]} ~ '
                                                                          : '${goalItem.startDate.toString().split(" ")[0]} ~ ${goalItem.endDate.toString().split(" ")[0]}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF667086),
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                      ),
                                                      child: Text(
                                                        dDay,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          // left: 0,
          right: 14,
          bottom: MediaQuery.of(context).padding.bottom + 10,
          child: SizedBox(
            width: 50,
            height: 50,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(_FullScreenPageRoute());
                },
                backgroundColor: Color(0xFF6046FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.add,
                  color: Color(0xFFFFFFFF),
                  size: 28,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _FullScreenPageRoute extends PageRouteBuilder {
  _FullScreenPageRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ShowModalNewGoal();
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
