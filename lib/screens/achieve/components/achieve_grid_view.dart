import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:provider/provider.dart';

class AchieveGridView extends StatefulWidget {
  final List<Map<String, dynamic>>? list;
  final Goal goal;
  final int? orderby;

  const AchieveGridView({
    super.key,
    required this.list,
    required this.goal,
    required this.orderby,
  });

  @override
  State<AchieveGridView> createState() => _AchieveGridViewState();
}

class _AchieveGridViewState extends State<AchieveGridView> {
  @override
  Widget build(BuildContext context) {
    // 널 체크 및 리스트 비어있을 경우 처리
    if (widget.list == null || widget.list!.isEmpty) {
      return const Center(child: Text('달성 기록이 없습니다.'));
    }

    List<Map<String, dynamic>> sortedList = List.from(widget.list!);

    switch (widget.orderby) {
      case 0:
        // 0일 때: createDate 최신순 (내림차순)
        sortedList.sort((a, b) {
          final DateTime dateA = a['createDate'] ?? DateTime(0);
          final DateTime dateB = b['createDate'] ?? DateTime(0);
          return dateB.compareTo(dateA); // 내림차순 (최신 날짜가 먼저)
        });
        break;
      case 1:
        // 1일 때: createDate 오래된 순 (오름차순)
        sortedList.sort((a, b) {
          final DateTime dateA = a['createDate'] ?? DateTime(0);
          final DateTime dateB = b['createDate'] ?? DateTime(0);
          return dateA.compareTo(dateB); // 오름차순 (오래된 날짜가 먼저)
        });
        break;
      case 2:
        // 2일 때: ✨ 복합 정렬: 1. 이미지 많은 순, 2. 최신순
        sortedList.sort((a, b) {
          final List<dynamic> imageListA = a['imageList'] ?? [];
          final List<dynamic> imageListB = b['imageList'] ?? [];

          final DateTime dateA = a['createDate'] ?? DateTime(0);
          final DateTime dateB = b['createDate'] ?? DateTime(0);

          // 1. 이미지 개수 비교 (내림차순: 많은 것이 먼저)
          int compareImageCount =
              imageListB.length.compareTo(imageListA.length);

          // 2. 이미지 개수가 같다면 (compareImageCount == 0),
          //    createDate를 기준으로 최신순 (내림차순) 정렬
          if (compareImageCount != 0) {
            return compareImageCount;
          } else {
            return dateB.compareTo(dateA); // 최신 날짜가 먼저 오도록
          }
        });
        break;
      // 기본값(null 또는 다른 값)은 정렬하지 않거나 기본 정렬 유지
      default:
        break;
    }

    int crossAxisCount = widget.list!.length == 1
        ? 1
        : widget.list!.length == 2
            ? 2
            : 3;
    double ratio = widget.list!.length == 1
        ? 0.92
        : widget.list!.length == 2
            ? 0.85
            : 0.78;

    String msg = context.read<TodoListProvider>().message;
    String author = context.read<TodoListProvider>().author;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: ratio,
          ),
          shrinkWrap: true,
          itemCount: sortedList.length,
          itemBuilder: (context, index) {
            final item = sortedList[index];
            final String mood = item['surveyMood'] ?? 'high'; // 무드 값 사용
            final String comment = item['surveyComment'] ?? '기록 내용 없음';
            final DateTime date = item['date'];
            final String day = '${date.year}.${date.month}.${date.day}';

            final List<dynamic> imageListDynamic = item['imageList'] ?? [];
            final RecordsImage? firstImage = imageListDynamic
                .whereType<RecordsImage>()
                .cast<RecordsImage>() // RecordsImage 타입으로 캐스팅
                .firstOrNull; // 첫 번째 이미지를 가져오거나 없으면 null

            final String imagePath = firstImage?.path ?? '';
            final int additionalImagesCount = imageListDynamic.length - 1;

            return GestureDetector(
              onTap: () {
                // print('page change!!');
                // context.push(
                //   '/recordSurveyDetail',
                //   extra: {
                //     'gemstone': widget.goal.gemstone,
                //     'title': widget.goal.title,
                //     'selectedDay': date,
                //     'goalId': widget.goal.goalId,
                //   },
                // );
              },
              child: Container(
                // width: 150,
                // height: 300,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFE2E2EA),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF101828).withOpacity(0.04),
                      spreadRadius: 0,
                      blurRadius: 2.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6, // 상하 패딩을 균일하게 조정
                      ),
                      child: AspectRatio(
                        // AspectRatio를 사용하여 이미지 영역의 높이를 동적으로 조정
                        aspectRatio: 1, // 정사각형 이미지 (width:height = 1:1)
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color.fromARGB(118, 0, 0, 0), // 테두리 색
                              width: 1, // 테두리 두께
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                imagePath.isNotEmpty
                                    ? Positioned.fill(
                                        child: Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                  child:
                                                      Icon(Icons.broken_image)),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Color(0xFF000000),
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                msg,
                                                textAlign: TextAlign.center,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff14161A),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '- $author',
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff14161A),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                // 추가 이미지 개수 오버레이
                                if (imageListDynamic.length > 1)
                                  Positioned(
                                    right: 6,
                                    bottom: 2,
                                    child: Text(
                                      '+$additionalImagesCount',
                                      style: const TextStyle(
                                        color: Color(0xff667086),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Color(0xFFECEEFF),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                'assets/icons/my-mood/$mood.svg',
                                color: Color(0xFF6046FF),
                                // width: 20,
                                // height: 20,
                                // fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff14161A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/*
child: Container(
  // width: 150,
  // height: 300,
  decoration: BoxDecoration(
    color: Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Color(0xFFE2E2EA),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF101828).withOpacity(0.04),
        spreadRadius: 0,
        blurRadius: 2.0,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6, // 상하 패딩을 균일하게 조정
        ),
        child: AspectRatio(
          // AspectRatio를 사용하여 이미지 영역의 높이를 동적으로 조정
          aspectRatio: 1, // 정사각형 이미지 (width:height = 1:1)
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imagePath.isNotEmpty
                ? Image.file(
                    // 💡 Image.file 사용
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                            child: Icon(Icons.broken_image)),
                      );
                    },
                  )
                : Container(
                    // 이미지가 없을 때 대체 UI
                    color: Colors.grey[100],
                    child: const Center(
                        child: Icon(Icons.camera_alt,
                            color: Colors.grey)),
                  ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 10, // 좌측 패딩 증가
          right: 10,
          bottom: 6,
          top: 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 무드 아이콘과 코멘트
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Color(0xFFE0ECFF),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    moodIcon, // 동적 무드 아이콘
                    color: moodColor, // 동적 색상
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  // 텍스트가 넘치지 않도록 Expanded 추가
                  child: Text(
                    comment
                        .split('\n')
                        .first, // 첫 줄만 표시하여 그리드 셀에 맞춤
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff14161A),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
),
*/
