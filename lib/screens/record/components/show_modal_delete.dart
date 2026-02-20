import 'package:flutter/material.dart';

class ShowModalDelete extends StatelessWidget {
  final DateTime selectedDay;

  const ShowModalDelete({
    super.key,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '기록을 삭제할까요?',
                  style: TextStyle(
                      color: Color(0xFF14161A),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
              Expanded(
                child: Text(
                  '${selectedDay.month}월 ${selectedDay.day}일 기록이 삭제됩니다.',
                  style: TextStyle(
                    color: Color(0xFF14161A),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                        Navigator.of(context).pop("delete");
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
  }
}
