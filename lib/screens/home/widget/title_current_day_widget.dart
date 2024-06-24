import 'package:flutter/material.dart';

class TitleCurrentDayWidget extends StatelessWidget {
  final DateTime currentTime = DateTime.now();

  TitleCurrentDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('${currentTime.year}년 ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400
              ),
            ),
            Text('${currentTime.month}월',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            print("알림");
          },
          icon: Image.asset(
              'assets/icons/notification-line.png'
          ),
        ),
      ],
    );
  }
}
