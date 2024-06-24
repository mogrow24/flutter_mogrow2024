import 'package:flutter/material.dart';


class DailyMessageWidget extends StatelessWidget {
  final String message;
  final String person;

  const DailyMessageWidget({
    super.key,
    required this.message,
    required this.person
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 60, bottom: 0, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600
            ),
          ),
          Text(
            person,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }
}
