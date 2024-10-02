import 'package:flutter/material.dart';

class ShowModalOrderby extends StatefulWidget {
  final int? initialCheckedIndex;

  const ShowModalOrderby({super.key, this.initialCheckedIndex});

  @override
  State<ShowModalOrderby> createState() => _ShowModalOrderbyState();
}

class _ShowModalOrderbyState extends State<ShowModalOrderby> {
  int? checkedIndex;

  List<String> arrangeList = ["최신순", "같은 목표 추가순", "색상순"];

  void _onOutsideTap() {
    if (checkedIndex != null) {
      Navigator.pop(context, {
        'arrange': arrangeList[checkedIndex!],
        'checkedIndex': checkedIndex,
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    checkedIndex = widget.initialCheckedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3, // 모달 높이 크기
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white, // 모달 배경색
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), // 모달 좌상단 라운딩 처리
          topRight: Radius.circular(25), // 모달 우상단 라운딩 처리
        ),
      ),
      child: Column(
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
                    '정렬',
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
          Expanded(
            child: ListView.builder(
              itemCount: arrangeList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      checkedIndex = index;
                    });
                    _onOutsideTap();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: Opacity(
                            opacity: checkedIndex == index ? 1.0 : 0.0,
                            child: Image.asset(
                              'assets/icons/check.png',
                              width: 24,
                              height: 24,
                              color: Color(0xFF0066FA),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(arrangeList[index]),
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
        ],
      ), // 모달 내부 디자인 영역
    );
  }
}
