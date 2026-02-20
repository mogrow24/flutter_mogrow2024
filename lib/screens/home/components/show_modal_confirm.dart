import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';

class ShowModalConfirm extends StatelessWidget {
  final DateTime selectedDay;
  final Todo todo;
  final String type;

  const ShowModalConfirm({
    super.key,
    required this.todo,
    required this.selectedDay,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (type == "delete") {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: todo.repeatCode != "0" ? 190 : 170,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    '할 일을 삭제할까요?',
                    style: TextStyle(
                        color: Color(0xFF14161A),
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                Expanded(
                  child: todo.repeatCode != "0"
                      ? Text(
                          '반복되는 할 일입니다.\n${selectedDay.month}월 ${selectedDay.day}일 이 후 모든 일정이 삭제됩니다.')
                      : Text(
                          '${selectedDay.month}월 ${selectedDay.day}일 일정이 삭제됩니다.',
                          style: TextStyle(
                            color: Color(0xFF14161A),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child:
                      // todo.repeatCode != "0"
                      //     ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.of(context).pop("repeatSelect");
                      //             },
                      //             child: Text(
                      //               '이 할 일만 삭제',
                      //               style: TextStyle(
                      //                 color: Color(0xFF0066FA),
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //           ),
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.of(context).pop("repeatAll");
                      //             },
                      //             child: Text(
                      //               '이후 모든 할 일 삭제',
                      //               style: TextStyle(
                      //                 color: Color(0xFF0066FA),
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     :
                      Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop("cancel"); // 취소
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
                          todo.repeatCode != "0"
                              ? Navigator.of(context).pop("repeatAll")
                              : Navigator.of(context).pop("delete");
                        },
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            color: Color(0xFF0066FA),
                            fontSize: 14,
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
        ),
      );
    } else {
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
                    '할 일을 수정할까요?',
                    style: TextStyle(
                        color: Color(0xFF14161A),
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text('수정됩니다.'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop("cancel"); // 취소
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
                          Navigator.of(context).pop("update"); // 수정
                        },
                        child: Text(
                          '수정',
                          style: TextStyle(
                            color: Color(0xFF0066FA),
                            fontSize: 14,
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
        ),
      );
    }
  }
}
