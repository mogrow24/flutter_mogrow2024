import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/screens/record/components/custom_grid_view.dart';

class LayoutPdfWidget extends StatelessWidget {
  // 상태 변화가 필요 없으므로 StatelessWidget 권장
  final String title;
  final List<Todo> todoList;
  final int completedCnt;
  final int listCnt;
  final Record record;
  final List<RecordsImage>? imageList;
  final String gemstone;
  final int pageNumber;
  final bool isSecondPageNeeded;
  final int currentPage;
  final int totalPage;

  const LayoutPdfWidget({
    super.key,
    required this.title,
    required this.todoList,
    required this.completedCnt,
    required this.listCnt,
    required this.record,
    this.imageList,
    required this.gemstone,
    required this.pageNumber,
    required this.isSecondPageNeeded,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            // width: 3000,
            height: 900,
            padding: EdgeInsets.symmetric(
                // vertical: 20,
                ),
            // color: Color(0xffF6F6F8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pageNumber == 1) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/gemstones/$gemstone.svg',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            title.length < 20
                                ? title
                                : '${title.substring(0, 18)} ...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF14161A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "$completedCnt/$listCnt",
                        style: const TextStyle(
                          color: Color(0xFF5C42FF),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  // 할 일 목록 (ListView 대신 Column 사용)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 28,
                    ),
                    child: Column(
                      children:
                          todoList.map((todo) => _buildTodoItem(todo)).toList(),
                    ),
                  ),
                  // --- 하단 코멘트 및 이미지 ---
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFFE0ECFF),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            'assets/icons/my-mood/${record.surveyMood}.svg',
                            color: const Color(0xFF0066FA),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Text(
                        record.surveyMood == 'high'
                            ? '완벽했던 하루'
                            : record.surveyMood == 'mid'
                                ? '괜찮았던 하루'
                                : '아쉬웠던 하루',
                        style: TextStyle(
                          color: Color(0xFF667086),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '• ${record.createDate!.year}-${record.createDate!.month}-${record.createDate!.day} ${record.createDate!.hour}:${record.createDate!.minute}에 기록',
                        style: TextStyle(
                          color: Color(0xFF667086),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    record.surveyComment,
                    style: TextStyle(
                      color: Color(0xFF14161A),
                      fontSize: 16,
                    ),
                  ),
                  // const SizedBox(height: 14),
                  // 이미지 그리드
                  CustomGridView(
                    imageList: imageList,
                    type: "pdf",
                  ),
                ],

                if (pageNumber == 2) ...[
                  CustomGridView(
                    imageList: imageList,
                    type: "pdf",
                  ),
                ],
                // const SizedBox(height: 100),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$title • ${record.createDate!.year}년 ${record.createDate!.month}월 ${record.createDate!.day}일",
                  style: TextStyle(color: Color(0xFF667086), fontSize: 12),
                ),
                Text("$currentPage / $totalPage",
                    style: TextStyle(color: Color(0xFF667086))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 할 일 아이템 위젯 분리
  Widget _buildTodoItem(Todo todo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle,
                  size: 7,
                  color: todo.isCompleted
                      ? const Color(0xFFBEC4CE)
                      : Colors.black),
              const SizedBox(width: 10),
              Text(
                todo.title,
                style: TextStyle(
                  color: todo.isCompleted
                      ? const Color(0xFFBEC4CE)
                      : const Color(0xFF14161A),
                  fontSize: 15,
                  decoration:
                      todo.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
          todo.isCompleted
              ? const Icon(Icons.check, color: Color(0xFF5C42FF), size: 18)
              : SvgPicture.asset('assets/icons/todo/working.svg',
                  width: 16, height: 16, color: const Color(0xFF667086)),
        ],
      ),
    );
  }
}
