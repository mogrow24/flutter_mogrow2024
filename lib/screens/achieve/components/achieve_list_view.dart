import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:provider/provider.dart';

class AchieveListView extends StatefulWidget {
  final List<Map<String, dynamic>>? list;
  final Goal goal;
  final int? orderby;
  final String? searchWord;

  const AchieveListView({
    super.key,
    required this.list,
    required this.goal,
    required this.orderby,
    this.searchWord,
  });

  @override
  State<AchieveListView> createState() => _AchieveListViewState();
}

class _AchieveListViewState extends State<AchieveListView> {
  // 각 리스트 항목의 확장 상태를 저장하는 맵
  // Key: item index, Value: isExpanded (bool)
  final Map<int, bool> _isExpanded = {};

  // loading
  bool _isLoading = false;

  // 확장 상태를 토글하고 UI를 업데이트하는 함수
  void _toggleExpand(int index) {
    setState(() {
      // 현재 상태를 반전시킵니다.
      _isExpanded[index] = !(_isExpanded[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 널 체크 추가
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

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: _isLoading
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF3C3C3C),
                  ),
                ),
              )
            : ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: sortedList.length,
                itemBuilder: (context, index) {
                  final item = sortedList[index];
                  final DateTime date = item['date'];
                  final DateTime createDate = item['createDate'];
                  final String mood = item['surveyMood'];
                  final String comment = item['surveyComment'];
                  final String day = '${date.year}.${date.month}.${date.day}';
                  final String createTime =
                      '${createDate.hour}:${createDate.minute}';

                  final List<dynamic> imageListDynamic =
                      item['imageList'] ?? [];
                  final List<RecordsImage> imageList = imageListDynamic
                      .whereType<RecordsImage>() // RecordsImage 타입만 필터링
                      .toList();

                  // 현재 항목의 확장 상태를 가져옵니다 (기본값: false)
                  final bool isExpanded = _isExpanded[index] ?? false;

                  // 이미지 존재 여부
                  final bool hasImages = imageList.isNotEmpty;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: InkWell(
                      onTap: () async {
                        final updatedRecord = await context.push(
                          '/recordSurveyDetail',
                          extra: {
                            'gemstone': widget.goal.gemstone,
                            'title': widget.goal.title,
                            'selectedDay': date,
                            'goalId': widget.goal.goalId,
                          },
                        );

                        if (updatedRecord == true) {
                          setState(() {
                            _isLoading = true;
                          });
                          await context
                              .read<RecordListProvider>()
                              .getRecordListByGoalId(widget.goal.goalId);
                          await Future.delayed(Duration(milliseconds: 500));

                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          // borderRadius: BorderRadius.circular(12),
                          // border: Border.all(
                          //   color: Color(0xFFE2E2EA),
                          //   width: 1,
                          // ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xFF101828).withOpacity(0.04),
                          //     spreadRadius: 0,
                          //     blurRadius: 2.0,
                          //     offset: Offset(0, 2),
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: Color(0xFFECEEFF),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(6),
                                          child: SvgPicture.asset(
                                            'assets/icons/my-mood/$mood.svg',
                                            color: Color(0xFF6046FF),
                                            // width: 20,
                                            // height: 20,
                                            // fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Text(
                                        '$day 한 일',
                                        style: TextStyle(
                                          color: Color(0xFF14161A),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Text(
                                        '$createTime에 기록',
                                        style: TextStyle(
                                          color: Color(0xFF667086),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        // 전체 항목 클릭 시 확장/축소
                                        _toggleExpand(index);
                                      },
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Color(0xFF3E4450),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AnimatedSize(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.searchWord == null ||
                                            widget.searchWord == ''
                                        ? Text(
                                            comment,
                                            style: TextStyle(
                                              color: Color(0xFF14161A),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            maxLines: isExpanded ? null : 3,
                                            overflow: isExpanded
                                                ? TextOverflow.visible
                                                : TextOverflow.ellipsis,
                                          )
                                        : _highlightedText(
                                            comment, widget.searchWord!),
                                  ],
                                ),
                              ),
                              if (hasImages) ...[
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imageList.length,
                                      itemBuilder: (context, imgIndex) {
                                        final RecordsImage recordImage =
                                            imageList[imgIndex];
                                        final String imagePath =
                                            recordImage.path;

                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: imgIndex ==
                                                      imageList.length - 1
                                                  ? 0
                                                  : 8),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Image.file(
                                              File(imagePath),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _highlightedText(String fullText, String query) {
    if (query.isEmpty ||
        !fullText.toLowerCase().contains(query.toLowerCase())) {
      // 검색어가 없거나 일치하는 게 없으면 일반 텍스트 반환
      return Text(
        '•  $fullText',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xff14161a),
          fontWeight: FontWeight.w400,
        ),
      );
    }

    // 검색어 기준으로 텍스트 분리 (대소문자 무시)
    final List<String> parts =
        fullText.split(RegExp(query, caseSensitive: false));

    // 실제 텍스트에서 검색어 부분을 찾아서 원본 대소문자를 유지하며 추출하기 위한 로직
    // (예: 검색어가 '플'이고 원본이 '플러터'면 '플'을 찾아냄)
    final matches =
        RegExp(query, caseSensitive: false).allMatches(fullText).toList();

    List<TextSpan> spans = [];
    spans.add(TextSpan(text: '•  ')); // 불렛 포인트 추가

    for (int i = 0; i < parts.length; i++) {
      // 일반 텍스트 부분
      spans.add(TextSpan(text: parts[i]));

      // 검색어와 일치하는 부분 (마지막 파트 뒤에는 검색어가 없으므로 제외)
      if (i < matches.length) {
        spans.add(TextSpan(
          text: matches[i].group(0), // 원본 텍스트에서의 검색어 부분
          style: TextStyle(
            color: Color(0xFF6046FF), // 하이라이트 색상 (보라색)
            fontWeight: FontWeight.w400,
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
            fontSize: 16,
            color: Color(0xff14161a),
            fontWeight: FontWeight.w400), // 기본 스타일
        children: spans,
      ),
    );
  }
}
