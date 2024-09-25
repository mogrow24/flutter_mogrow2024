import 'package:flutter/material.dart';
import 'package:mogrow/screens/home/addTodo/model/goal.dart';
import 'package:mogrow/widget/show_modal_add_goal.dart';

class ShowModal extends StatefulWidget {
  final int? initialCheckedIndex;

  const ShowModal({super.key, this.initialCheckedIndex});

  @override
  State<ShowModal> createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  final List<Goal> goals = [
    Goal(goalName: '없음', goalColor: 'core.png'),
    Goal(goalName: '사이드 프로젝트 런칭', goalColor: 'ruby.png'),
    Goal(goalName: '3분기 버킷리스트', goalColor: 'sunstone.png'),
    Goal(goalName: '여행 계획', goalColor: 'citrine.png'),
  ];

  int? checkedIndex;

  void _onOutsideTap() {
    if (checkedIndex != null) {
      Navigator.pop(context, {
        'goal': goals[checkedIndex!],
        'checkedIndex': checkedIndex,
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    checkedIndex = widget.initialCheckedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35, // 모달 높이 크기
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white, // 모달 배경색
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), // 모달 좌상단 라운딩 처리
          topRight: Radius.circular(25), // 모달 우상단 라운딩 처리
        ),
      ),
      child: Column(
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
                      // widget.onClose();
                      // Navigator.pop(context).then((_) {
                      //   showModalBottomSheet(
                      //     barrierColor: Colors.transparent,
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return Text('gd');
                      //     },
                      //   );
                      // });
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
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      checkedIndex = index;
                    });
                    _onOutsideTap();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 35,
                          width: 35,
                          // child: Icon(
                          //   checkedItems.contains(index)
                          //       ? Icons.check_box
                          //       : Icons.check_box_outline_blank,
                          //   color: checkedItems.contains(index)
                          //       ? Colors.blue
                          //       : Colors.grey,
                          // ),
                          child: Opacity(
                            opacity: checkedIndex == index ? 1.0 : 0.0,
                            child: Image.asset(
                              'assets/icons/check.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF0066FA),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(goals[index].goalName),
                                Image.asset(
                                    'assets/icons/gemstones/${goals[index].goalColor}'),
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
        ],
      ), // 모달 내부 디자인 영역
    );
  }
}
