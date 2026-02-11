import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/screens/home/components/show_modal_add_goal.dart';
import 'package:provider/provider.dart';

class ShowModalSelectGoal extends StatefulWidget {
  final int? initialCheckedIndex;
  final String? initialCheckedId;

  const ShowModalSelectGoal(
      {super.key, this.initialCheckedIndex, this.initialCheckedId});

  @override
  State<ShowModalSelectGoal> createState() => _ShowModalSelectGoalState();
}

class _ShowModalSelectGoalState extends State<ShowModalSelectGoal> {
  int? checkedIndex;
  String? selectedId;

  late List<Goal> _goalList = [];

  // loading
  bool _isLoading = true;

  void _onOutsideTap(Goal goal, int index) {
    if (selectedId != null) {
      Navigator.pop(context, {
        'goal': goal,
        'selectedId': _goalList[index].goalId,
      });
    } else {
      Navigator.pop(context);
    }
    // if (checkedIndex != null) {
    // Navigator.pop(context, {
    //   'goal': goals[checkedIndex!],
    //   'checkedIndex': checkedIndex,
    // });
    // } else {
    //   Navigator.pop(context);
    // }
    setState(() {
      checkedIndex = index;
      selectedId = _goalList[index].goalId;
    });
  }

  @override
  void initState() {
    super.initState();
    checkedIndex = widget.initialCheckedIndex;
    selectedId = widget.initialCheckedId;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final goalProvider =
          Provider.of<GoalListProvider>(context, listen: false);
      await goalProvider.fetchGoals();
      await Future.delayed(Duration(milliseconds: 400));

      setState(() {
        _isLoading = false;
        _goalList = goalProvider.goalList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8, // 최대 높이 제한
          minHeight: 250, // 최소 높이
        ),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white, // 모달 배경색
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), // 모달 좌상단 라운딩 처리
            topRight: Radius.circular(25), // 모달 우상단 라운딩 처리
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 14,
            ),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Color(0xFFBEC4CE),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              // child: ,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 48,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '목표 선택',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14161A),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      // style:
                      //     ButtonStyle(overlayColor: WidgetStateColor.transparent),
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ShowModalAddGoal();
                          },
                        );
                      },
                      child: Text(
                        '새로 만들기',
                        style: TextStyle(
                          color: Color(0xFF0066FA),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: _isLoading
                  ? Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF3C3C3C),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _goalList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            _onOutsideTap(_goalList[index], index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Opacity(
                                      opacity:
                                          selectedId == _goalList[index].goalId
                                              ? 1.0
                                              : 0.0,
                                      child: Icon(
                                        Icons.check_outlined,
                                        color: Color(0xFF0066FA),
                                        size: 24,
                                      )),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_goalList[index].title),
                                        SvgPicture.asset(
                                            'assets/icons/gemstones/${_goalList[index].gemstone}.svg'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ), // 모달 내부 디자인 영역
      ),
    );
  }
}
