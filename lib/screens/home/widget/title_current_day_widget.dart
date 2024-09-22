import 'package:flutter/material.dart';

class TitleCurrentDayWidget extends StatefulWidget {
  final int year;
  final int month;

  const TitleCurrentDayWidget({super.key, required this.year, required this.month});

  @override
  State<TitleCurrentDayWidget> createState() => _TitleCurrentDayWidgetState();
}

class _TitleCurrentDayWidgetState extends State<TitleCurrentDayWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('${widget.year}년 ',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400
              ),
            ),
            Text('${widget.month}월',
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
