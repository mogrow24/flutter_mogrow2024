import 'package:flutter/material.dart';

class ShowModalSelectGoalColor extends StatefulWidget {
  const ShowModalSelectGoalColor({super.key});

  @override
  State<ShowModalSelectGoalColor> createState() =>
      _ShowModalSelectGoalColorState();
}

class _ShowModalSelectGoalColorState extends State<ShowModalSelectGoalColor> {
  final List<String> items = [
    'core.png',
    'ruby.png',
    'sunstone.png',
    'citrine.png',
    'sphene.png',
    'emerald.png',
    'aquamarine.png',
    'sapphire.png',
    'tanzanite.png',
    'amethyst.png',
    'rose-quartz.png',
    'smoky-quartz.png',
  ];

  final List<String> itemNames = [
    '없음',
    '루비',
    '선스톤',
    '시트린',
    '스펜',
    '에메랄드',
    '아쿠아마린',
    '사파이어',
    '탄자나이트',
    '아메디스트',
    '로즈쿼츠',
    '스모키쿼츠',
  ];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5, // 모달 높이 크기
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
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '목표 색상 선택',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14161A),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4x4 그리드
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 80
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      // 원하는 동작 추가
                      // print('${items[index]} selected');
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.pop(context, {'image': items[index], 'name': itemNames[index]});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? Color(0xFFECECF0)
                            : null
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/gemstones/${items[index]}',
                            width: 36,
                            height: 36,
                          ),
                          SizedBox(height: 15,),
                          Text(
                            itemNames[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF14161A),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ), // 모달 내부 디자인 영역
    );
  }
}
