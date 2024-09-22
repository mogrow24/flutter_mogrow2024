import 'package:flutter/material.dart';
import 'package:momentum/widget/show_modal_new_goal.dart';
import 'package:momentum/widget/show_modal_select_goal.dart';

class ShowModalAddGoal extends StatefulWidget {
  const ShowModalAddGoal({super.key});

  @override
  State<ShowModalAddGoal> createState() => _ShowModalAddGoalState();
}

class _ShowModalAddGoalState extends State<ShowModalAddGoal> {

  void _showSelectGoalModal() {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ShowModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25, // 모달 높이 크기
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white, // 모달 배경색
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), // 모달 좌상단 라운딩 처리
          topRight: Radius.circular(25), // 모달 우상단 라운딩 처리
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              height: 40,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '원하는 목표를 만들고 성취해보세요!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF14161A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(_FullScreenPageRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0066FA),
                    surfaceTintColor: Color(0xFF0066FA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(0, 52),
                  ),
                  child: Text(
                    '만들기',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _showSelectGoalModal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    foregroundColor: Color(0xFF3E4450),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(0, 52),
                    elevation: 0,
                  ),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), // 모달 내부 디자인 영역
    );
  }
}

class _FullScreenPageRoute extends PageRouteBuilder {
  _FullScreenPageRoute()
      : super(
    pageBuilder: (context, animation, secondaryAnimation) {
      return FullScreenModal();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}