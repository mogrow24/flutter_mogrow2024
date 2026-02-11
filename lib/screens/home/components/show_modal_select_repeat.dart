import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowModalSelectRepeat extends StatefulWidget {
  final int? initialCheckedIndex;
  final DateTime? selectedDay;

  const ShowModalSelectRepeat(
      {super.key, this.initialCheckedIndex, this.selectedDay});

  @override
  State<ShowModalSelectRepeat> createState() => _ShowModalSelectRepeatState();
}

class _ShowModalSelectRepeatState extends State<ShowModalSelectRepeat> {
  String strToday = '';
  int? checkedIndex;
  String? dayText;

  final List<Map<int, String>> items = [
    {0: '반복 안함'},
    {1: '매일'},
    {2: '매주 평일'},
    {3: '매주'},
    {4: '격주'},
    {5: '매월'},
    {6: '매월'},
    {7: '매월'},
    {8: '매년'},
  ];

  String? getDayText(int index) {
    switch (index) {
      case 2:
        return '(월-금)';
      case 3:
        return '${strToday.split('(')[1].substring(0, 1)}요일';
      case 4:
        return '${strToday.split('(')[1].substring(0, 1)}요일';
      case 5:
        return strToday.substring(3, 7);
      case 6:
        return '넷째 주 ${strToday.split('(')[1].substring(0, 1)}요일';
      case 7:
        return '마지막 주 ${strToday.split('(')[1].substring(0, 1)}요일';
      case 8:
        return strToday.substring(0, 7);
      default:
        return null; // 나머지 인덱스는 추가 텍스트 없음
    }
  }

  void _onOutsideTap() {
    if (checkedIndex != null) {
      Navigator.pop(context, {
        'selectedRepeat': items[checkedIndex!],
        'checkedIndex': checkedIndex,
        'dayText': getDayText(checkedIndex!) ?? '',
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    DateFormat formatter = DateFormat('M월 d일 (E)', 'ko');
    strToday = formatter.format(widget.selectedDay!);

    checkedIndex = widget.initialCheckedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.52, // 모달 높이 크기
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white, // 모달 배경색
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), // 모달 좌상단 라운딩 처리
            topRight: Radius.circular(25), // 모달 우상단 라운딩 처리
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 14,
            ),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Color(0xFFBEC4CE),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              // child: ,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 48,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '$strToday 반복',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14161A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  dayText = getDayText(index);
                  final entry = items[index].entries.first;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        checkedIndex = index;
                      });
                      _onOutsideTap();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            // child: Icon(
                            //   checkedItems.contains(index)
                            //       ? Icons.check_box
                            //       : Icons.check_box_outline_blank,
                            //   color: checkedItems.contains(index)
                            //       ? Colors.blue
                            //       : Colors.grey,
                            // ),
                            child: Opacity(
                                opacity: checkedIndex == index ? 1.0 : 0.0,
                                child: Icon(
                                  Icons.check_outlined,
                                  color: Color(0xFF0066FA),
                                  size: 24,
                                )),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(entry.value),
                                  if (dayText != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        '$dayText',
                                        style: TextStyle(
                                          color: Color(0xFF667086),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ), // 모달 내부 디자인 영역
      ),
    );
  }
}
