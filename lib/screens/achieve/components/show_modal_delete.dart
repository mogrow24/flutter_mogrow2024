import 'package:flutter/material.dart';

class ShowModalDelete extends StatelessWidget {
  const ShowModalDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 190,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  '목표를 삭제할까요?',
                  style: TextStyle(
                      color: Color(0xFF14161A),
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
              Expanded(
                child: Text(
                  '목표와 기록은 모두 삭제되며,\n복원 되지 않습니다.',
                  style: TextStyle(
                    color: Color(0xFF14161A),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
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
                          color: Color(0xFF6046FF),
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
                          color: Color(0xFF6046FF),
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
