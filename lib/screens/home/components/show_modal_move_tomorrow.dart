import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:provider/provider.dart';

class ShowModalMoveTomorrow extends StatelessWidget {
  final DateTime selectedDay;
  final Todo todo;

  const ShowModalMoveTomorrow(
      {super.key, required this.selectedDay, required this.todo});

  @override
  Widget build(BuildContext context) {
    String formattedTomorrow =
        DateFormat('M월 d일', 'ko_KR').format(selectedDay.add(Duration(days: 1)));
    final provider = Provider.of<TodoListProvider>(context, listen: false);

    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 170,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  '내일로 미룰까요?',
                  style: TextStyle(
                      color: Color(0xFF14161A),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
              Expanded(child: Text('$formattedTomorrow 일정으로 이동합니다.')),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(
                          color: Color(0xFF0066FA),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.updateTodoTomorrow(todo, todo.date!);

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(
                          color: Color(0xFF0066FA),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
