import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/achieve_list.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/screens/achieve/components/achieve_list_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 추가

class RecordSearch extends StatefulWidget {
  const RecordSearch({super.key});

  @override
  State<RecordSearch> createState() => _RecordSearchState();
}

class _RecordSearchState extends State<RecordSearch> {
  // 1. 필요한 컨트롤러 및 변수 선언
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // 포커스 감지용

  List<String> _recentSearches = [];
  List<String> _filteredResults = [];
  List<Todo> _todoList = [];
  List<Record> _recordList = [];
  late Goal _goal;

  final String _historyKey = 'recent_searches_key';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory(); // 시작할 때 기존 기록 불러오기

    // 포커스 변화를 감지하기 위한 리스너 추가
    _focusNode.addListener(() {
      setState(() {}); // 포커스 상태가 바뀔 때 UI를 다시 그립니다.
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 넘겨 받은 데이터
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
      final goal = extra['goal'];

      setState(() {
        _goal = goal;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  // 2. 검색어 불러오기
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList(_historyKey) ?? [];
    });
  }

  // 3. 검색어 저장하기
  Future<void> _saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    // 중복 제거 후 맨 앞에 추가
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);

    // 최대 10개까지만 저장
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }

    await prefs.setStringList(_historyKey, _recentSearches);
    setState(() {});
  }

  // 실시간 필터링 로직
  void _onSearchChanged(String query, String goalId) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredResults = [];
      });
      return;
    }

    // context.read<AchieveListProvider>().searchByGoalId(query, goalId);
    final todoList = await context
        .read<AchieveListProvider>()
        .todoListBySearchWord(query, goalId);
    final recordList = await context
        .read<AchieveListProvider>()
        .recordListBySearchWord(query, goalId);

    setState(() {
      _isSearching = true;
      // DB 결과와 기존 검색 기록 매칭 결과를 합칩니다 (중복 제거)
      // _filteredResults = {...dbResults, ...historyMatches}.toList();
      _todoList = todoList;
      _recordList = recordList;
    });
  }

  // 4. 검색어 개별 삭제
  Future<void> _deleteSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    await prefs.setStringList(_historyKey, _recentSearches);
    setState(() {});
  }

  // 모든 검색어 삭제
  Future<void> _clearAllSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey); // 저장소에서 삭제
    setState(() {
      _recentSearches = []; // UI 상태 초기화
    });
  }

  List<bool> isSelected = [true, false];
  void _toggleButton(int index) {
    if (isSelected[index]) {
      // 이미 선택된 버튼을 다시 클릭할 때는 아무 동작도 하지 않음
      return;
    }
    setState(() {
      isSelected[0] = index == 0;
      isSelected[1] = index == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final goal = extra['goal'];

    return GestureDetector(
      onTap: () {
        // 화면의 다른 곳을 누르면 포커스를 해제합니다.
        FocusScope.of(context).unfocus();
      },
      // behavior 속성을 opaque로 설정해야 빈 공간 터치를 잘 감지합니다.
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: TextButton(
            onPressed: () => context.pop(),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.black, size: 24),
          ),
          title: Text(
            goal.title,
            style: const TextStyle(
                color: Color(0xFF14161A),
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // --- 검색창 영역 ---
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Color(0xFF212121),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode, // 포커스 노드 연결
                            // onChanged: _onSearchChanged, // 글자 입력할 때마다 호출
                            onSubmitted: (value) {
                              _saveSearchQuery(value); // 엔터 누르면 저장
                              // _controller.clear(); // 입력창 비우기 (필요시)
                              _onSearchChanged(value, goal.goalId);
                              _focusNode.unfocus();
                            },
                            decoration: const InputDecoration(
                              hintText: '검색어를 입력하세요',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEfEfef), thickness: 1),

              if (_focusNode.hasFocus || _isSearching)
                Expanded(
                  child: Container(
                    color: Color(0xffF6F6F8),
                    child: !_focusNode.hasFocus
                        ? _buildFilteredList() // 타이핑 중일 땐 검색 결과
                        : _buildRecentSearchList(
                            goal.goalId), // 그냥 클릭했을 땐 최근 검색어
                  ),
                )
              else
                Expanded(
                  child: Container(
                    color: Color(0xffF6F6F8),
                  ),
                ), // 포커스 없을 땐 빈 화면

              // --- 최근 검색어 목록 영역 ---
              // Flexible(
              //   child: Container(
              //     width: double.infinity,
              //     color: const Color(0xffF6F6F8),
              //     child: _recentSearches.isEmpty
              //         ? const Center(child: Text('최근 검색어가 없습니다.'))
              //         : ListView.builder(
              //             itemCount: _recentSearches.length,
              //             itemBuilder: (context, index) {
              //               final item = _recentSearches[index];
              //               return ListTile(
              //                 leading: const Icon(Icons.access_time,
              //                     size: 20, color: Colors.grey),
              //                 title: Text(item,
              //                     style: const TextStyle(fontSize: 15)),
              //                 trailing: GestureDetector(
              //                   onTap: () => _deleteSearchQuery(item),
              //                   child: const Icon(Icons.close,
              //                       size: 18, color: Colors.grey),
              //                 ),
              //                 onTap: () {
              //                   // 검색어 클릭 시 검색창에 채우기
              //                   _controller.text = item;
              //                 },
              //               );
              //             },
              //           ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. 최근 검색어 목록 빌더
  Widget _buildRecentSearchList(String goalId) {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Text(
          '최근 검색 기록이 없습니다',
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
            top: 15,
            bottom: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 검색어',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14141A),
                ),
              ),
              GestureDetector(
                onTap: _clearAllSearches, // 전체 삭제 함수 호출
                child: Text(
                  '전체 삭제',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFA0A0AB),
                      fontWeight: FontWeight.w400
                      // decoration: TextDecoration.underline, // 밑줄 효과 (선택사항)
                      ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final item = _recentSearches[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                child: ListTile(
                  // leading: const Icon(Icons.access_time, size: 20),
                  title: Text(
                    item,
                    style: TextStyle(
                      color: Color(0xFF72727E),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _deleteSearchQuery(item),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFFD4D4D9),
                    ),
                  ),
                  onTap: () {
                    _controller.text = item;
                    // _onSearchChanged(item, goalId);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 2. 실시간 매칭 검색어 목록 빌더
  Widget _buildFilteredList() {
    // 1. 현재 검색어 가져오기
    String query = _controller.text.toLowerCase();
    List<Todo> filteredTodos;

    // 2. 검색어가 포함된 Todo만 먼저 필터링
    Set<String> matchedMonths = _todoList
        .where((item) => item.title.toLowerCase().contains(query))
        .map((item) =>
            "${item.date!.year}-${item.date!.month}-${item.date!.day}")
        .toSet();

    // 2단계: 일치하는 날에 속한 모든 데이터를 필터링
    filteredTodos = _todoList.where((item) {
      String itemMonth =
          "${item.date!.year}-${item.date!.month}-${item.date!.day}";
      return matchedMonths.contains(itemMonth);
    }).toList();

    Map<DateTime, List<Todo>> groupedTodoList = {};
    for (var item in filteredTodos) {
      DateTime date = item.date!;
      DateTime normal = DateTime(date.year, date.month, date.day);
      if (!groupedTodoList.containsKey(normal)) {
        groupedTodoList[normal] = [];
      }
      groupedTodoList[normal]!.add(item);
    }

    List<DateTime> sortTodoList = groupedTodoList.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final allRecords = context.read<RecordListProvider>().processedRecordData;
    // 검색어가 포함된 Record만 추출
    List<Map<String, dynamic>> filteredRecords = allRecords.where((record) {
      if (query.isEmpty) return true; // 검색어가 없으면 전체 노출

      // surveyComment가 null일 수 있으므로 안전하게 처리
      final comment = record['surveyComment']?.toString().toLowerCase() ?? '';

      return comment.contains(query);
    }).toList();

    if (sortTodoList.isEmpty && filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '검색 결과가 없습니다',
              style: TextStyle(
                color: Color(0xFF14141A),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '검색어를 바르게 입력했는지 확인해주세요',
              style: TextStyle(
                color: Color(0xFFA0A0AB),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: 10,
            left: 10,
            top: 8,
            bottom: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...[0, 1].map((index) {
                final screenWidth = MediaQuery.of(context).size.width;
                final buttonWidth = (screenWidth - 40 - 16) / 2;

                return TextButton(
                  onPressed: () {
                    _toggleButton(index);
                  },
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    overlayColor:
                        WidgetStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Container(
                    width: buttonWidth,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isSelected[index]
                          ? Color(0xFF6046FF)
                          : Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFE2E2EA),
                        width: 0.1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF101828).withOpacity(0.20),
                          blurRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        index == 0 ? '목표를 위해 했던 일' : '나의 과정 기록',
                        style: TextStyle(
                          color:
                              isSelected[index] ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        isSelected[0]
            ? sortTodoList.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '검색된 할일이 없습니다',
                            style: TextStyle(
                              color: Color(0xFF14141A),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '검색어를 바르게 입력했는지 확인해주세요',
                            style: TextStyle(
                              color: Color(0xFFA0A0AB),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                        // left: 20,
                        // right: 20,
                        top: 15,
                        bottom: 10,
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Color(0xFFFFFFFF),
                              // borderRadius: BorderRadius.circular(8),
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
                          child: ListView.builder(
                              itemCount: sortTodoList.length,
                              itemBuilder: (context, index) {
                                DateTime date = sortTodoList[index];
                                List<Todo> items = groupedTodoList[date]!;

                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    bottom: 30,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat('yyyy-MM-dd')
                                                .format(date),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff667086),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          SvgPicture.asset(
                                            'assets/icons/record/record_fill.svg',
                                            width: 18,
                                            height: 18,
                                            color: Color(0xFF5C42FF),
                                          ),
                                        ],
                                      ),
                                      ...items.map(
                                        (item) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Text(
                                            //   '• ${item.title}',
                                            //   style: TextStyle(
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.w400,
                                            //       color: Color(0xff14161a)),
                                            // ),
                                            _highlightedText(
                                                item.title, _controller.text),

                                            item.isCompleted
                                                ? Icon(
                                                    Icons.check_rounded,
                                                    color: Color(0xFF5C42FF),
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/icons/todo/working.svg',
                                                    width: 18,
                                                    height: 18,
                                                    color: Color(0xFF667086),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                    ),
                  )
            : filteredRecords.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '검색된 기록이 없습니다',
                            style: TextStyle(
                              color: Color(0xFF14141A),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '검색어를 바르게 입력했는지 확인해주세요',
                            style: TextStyle(
                              color: Color(0xFFA0A0AB),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : AchieveListView(
                    goal: _goal,
                    list: filteredRecords,
                    orderby: 0,
                    searchWord: query,
                  ),
        // Flexible(
        //     child: Padding(
        //       padding: EdgeInsets.only(
        //         // left: 20,
        //         // right: 20,
        //         top: 15,
        //         bottom: 10,
        //       ),
        //       child: Container(
        //         decoration: BoxDecoration(),
        //       ),
        //     ),
        //   )
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: _filteredResults.length,
        //     itemBuilder: (context, index) {
        //       final item = _filteredResults[index];
        //       return ListTile(
        //         leading: const Icon(Icons.search, size: 20),
        //         title: Text(item),
        //         trailing: GestureDetector(
        //           onTap: () => _deleteSearchQuery(item),
        //           child: const Icon(Icons.close, size: 18, color: Colors.grey),
        //         ),
        //         onTap: () {
        //           _saveSearchQuery(item); // 클릭한 것도 최근 검색어에 저장
        //           _controller.text = item;
        //           _focusNode.unfocus();
        //         },
        //       );
        //     },
        //   ),
        // ),
      ],
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
