// 정렬 모달 창
import 'package:flutter/material.dart';

class OrderbyModal extends StatefulWidget {
  final int? initialCheckedIndex;

  const OrderbyModal({super.key, this.initialCheckedIndex});

  @override
  State<OrderbyModal> createState() => _OrderbyModalState();
}

class _OrderbyModalState extends State<OrderbyModal> {
  int? checkedIndex;

  List<String> arrangeList = ["최신순", "목표순", "색상순"];

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
      // height: MediaQuery.of(context).size.height * 0.3, // 모달 높이 크기
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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                          child: Icon(
                            Icons.check_outlined,
                            color: Color(0xFF0066FA),
                            size: 24,
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
          SizedBox(height: 20),
        ],
      ), // 모달 내부 디자인 영역
    );
  }
}
