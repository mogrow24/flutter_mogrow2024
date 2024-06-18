import 'package:flutter/material.dart';

class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white, //색상
      child: Container(
        height: 70,
        padding: EdgeInsets.only(bottom: 10, top: 5),
        child: TabBar(
          //tab 하단 indicator size -> .label = label의 길이
          //tab 하단 indicator size -> .tab = tab의 길이
          indicatorSize: TabBarIndicatorSize.label,
          //tab 하단 indicator color
          indicatorColor: Colors.red,
          //tab 하단 indicator weight
          indicatorWeight: 2,
          //label color
          labelColor: Colors.red,
          //unselected label color
          unselectedLabelColor: Colors.black38,
          labelStyle: TextStyle(
            fontSize: 13,
          ),
          tabs: [
            Tab(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  "assets/icons/home/line.png",
                ),
              ),
              text: '홈',
            ),
            Tab(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  "assets/icons/record/line.png",
                ),
              ),
              text: '기록',
            ),
            Tab(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  "assets/icons/achieve/line.png",
                ),
              ),
              text: '달성',
            ),
          ],
        ),
      ),
    );
  }
}