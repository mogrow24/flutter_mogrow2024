import 'package:flutter/material.dart';

class DailyMessageWidget extends StatefulWidget {
  final String message;
  final String author;

  const DailyMessageWidget(
      {super.key, required this.message, required this.author});

  @override
  State<DailyMessageWidget> createState() => _DailyMessageWidgetState();
}

class _DailyMessageWidgetState extends State<DailyMessageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 20, bottom: 10, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          Text(
            widget.author,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
