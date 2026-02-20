import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/providers/photo_manager.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/record/components/album_select_view.dart';
import 'package:mogrow/screens/record/components/photo_display_widget.dart';
import 'package:mogrow/screens/record/components/thumbnail_widget.dart';
import 'package:provider/provider.dart';

class RecordSurvey extends StatefulWidget {
  const RecordSurvey({super.key});

  @override
  State<RecordSurvey> createState() => _RecordSurveyState();
}

class _RecordSurveyState extends State<RecordSurvey> {
  final TextEditingController _controller = TextEditingController();
  int _characterCount = 0;
  final int _maxLength = 1000;
  final int _maxLines = 6;
  final FocusNode _textFocus = FocusNode();

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _controller.text.length;
    });
  }

  // Accordion 관련
  bool _isExpanded = false;

  // 만족도 선택 관련
  bool _isMoodSelected = false;
  bool _selectedHigh = false;
  bool _selectedMid = false;
  bool _selectedLow = false;
  String _selectedMood = '';

  // 사진 형태
  final int _selected = 0;

  void _selectMood(String mood) {
    setState(() {
      _isMoodSelected = true;

      if (mood == '완벽했어요!') {
        _selectedHigh = true;
        _selectedMid = false;
        _selectedLow = false;
        _selectedMood =
            '오늘을 완벽한 하루로 만든 비결은 무엇이었나요? 그 순간의 기쁨, 달성감, 그리고 오늘 하루를 돌아볼 때 미소 짓게 하는 모든 것들에 대해 자세히 적어보세요.\n작은 매일의 기록들은 나중에 더 큰 영감을 줄 거예요.';
      } else if (mood == '괜찮았어요!') {
        _selectedHigh = false;
        _selectedMid = true;
        _selectedLow = false;
        _selectedMood =
            '오늘 하루도 자신과의 약속을 지키며 열심히 살아냈군요!\n오늘의 경험 속에서 배우고 싶은 교훈이나 내일을 위한 개선 사항이 있다면 작성해 보세요.\n작은 변화가 모여 큰 성장으로 이어진답니다!';
      } else {
        _selectedHigh = false;
        _selectedMid = false;
        _selectedLow = true;
        _selectedMood =
            '모든 날이 완벽할 순 없죠. 오늘의 아쉬움은 내일의 성장을 위한 소중한 밑거름이 될 수 있어요.\n오늘 겪은 어려움, 그로 인해 느낀 감정들, 그리고 앞으로 어떻게 해나가고 싶은지에 대해 자유롭게 표현해 보세요.\n솔직한 기록이 내일을 위한 힘찬 발판이 될 거예요.';
      }
    });
  }

  @override
  void initState() {
    _controller.addListener(_updateCharacterCount);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PhotoManagerProvider>().clearData();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCharacterCount);
    _controller.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoListProvider>(context);
    final goalProvider = Provider.of<GoalListProvider>(context);
    final recordProvider = Provider.of<RecordListProvider>(context);

    // 비머로 넘겨 받은 데이터
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final title = extra['title'];
    final gemstone = extra['gemstone'];
    final selectedDay = extra['selectedDay'];
    final goalId = extra['goalId'];

    final todoList = todoProvider.getListByGoalId(goalId, selectedDay);

    final photoManager = context.watch<PhotoManagerProvider>();
    // final photoManager =
    //     Provider.of<PhotoManagerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFFECECF0),
            width: 1,
          ),
        ),
        leading: TextButton(
          onPressed: () {
            context.pop();
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
                onPressed: () async {
                  if (_characterCount > 0) {
                    String mood =
                        _selectedHigh ? "high" : (_selectedMid ? "mid" : "low");
                    final customId = await recordProvider.getNextCustomId();

                    final newRecord = Record(
                      recordId: customId,
                      surveyMood: mood,
                      surveyComment: _controller.text,
                      date: selectedDay,
                      status: true,
                      goalId: goalId,
                    );

                    await recordProvider.addRecord(
                        newRecord, photoManager.selectedImageList);

                    if (mounted) {
                      context.pop();
                    }
                  }
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  '기록하기',
                  style: TextStyle(
                    color: _characterCount < 1
                        ? Color(0xFFBEC4CE)
                        : Color(0xFF5C42FF),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                )),
          ),
        ],
        title: Text(
          DateFormat('yyyy년 MM월 dd일', 'ko').format(selectedDay),
          style: TextStyle(
            color: Color(0xFF14161A),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Color(0xffF6F6F8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 48,
                                    // minWidth: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF101828).withOpacity(0.04),
                                        spreadRadius: 0,
                                        blurRadius: 2.0,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/gemstones/$gemstone.svg',
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ),
                                                Text(
                                                  '$title',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF14161A),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _isExpanded
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 14,
                                                    ),
                                                    child: Text(
                                                      "${todoProvider.getCompleltedCnt(goalId, selectedDay)}/${todoProvider.getListCntByGoalId(goalId, selectedDay)}",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFF5C42FF),
                                                      ),
                                                    ),
                                                  )
                                                : IconButton(
                                                    padding: EdgeInsets.zero,
                                                    style: ButtonStyle(
                                                      overlayColor:
                                                          WidgetStateProperty
                                                              .all<Color>(Colors
                                                                  .transparent),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isExpanded =
                                                            !_isExpanded; // 버튼 클릭 시 상태 토글
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      AnimatedSize(
                                        duration: Duration(
                                            milliseconds: 400), // 애니메이션 시간
                                        curve: Curves.easeInOut, // 애니메이션 곡선
                                        child: _isExpanded
                                            ? Container(
                                                // constraints: BoxConstraints(
                                                //   maxHeight: 120,
                                                //   minHeight: 48,
                                                // minWidth: double.infinity,
                                                // ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 20,
                                                        horizontal: 24,
                                                      ),
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxHeight: 120,
                                                          minHeight: 48,
                                                        ),
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              todoList.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final todoItem =
                                                                todoList[index];

                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    todoItem.isCompleted
                                                                        ? Icon(
                                                                            Icons.circle,
                                                                            size:
                                                                                7,
                                                                            color:
                                                                                Color(0xFFBEC4CE),
                                                                          )
                                                                        : Icon(
                                                                            Icons.circle,
                                                                            size:
                                                                                7,
                                                                          ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    todoItem.isCompleted
                                                                        ? Text(
                                                                            todoItem.title,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFBEC4CE),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 14,
                                                                              decoration: TextDecoration.lineThrough,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            todoItem.title,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFF14161A),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 14,
                                                                            ),
                                                                          )
                                                                  ],
                                                                ),
                                                                todoItem
                                                                        .isCompleted
                                                                    ? Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Color(
                                                                            0xFF5C42FF),
                                                                        size:
                                                                            16,
                                                                      )
                                                                    : SvgPicture
                                                                        .asset(
                                                                        'assets/icons/todo/working.svg',
                                                                        width:
                                                                            16,
                                                                        height:
                                                                            16,
                                                                        color: Color(
                                                                            0xFF667086),
                                                                      ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      color: Colors.grey,
                                                      thickness: 0.2,
                                                    ),
                                                    SizedBox(
                                                      height: 36,
                                                      child: IconButton(
                                                        style: ButtonStyle(
                                                          overlayColor:
                                                              WidgetStateProperty
                                                                  .all<Color>(
                                                            Colors.transparent,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _isExpanded =
                                                                !_isExpanded; // 버튼 클릭 시 상태 토글
                                                          });
                                                        },
                                                        icon: Image.asset(
                                                          'assets/icons/arrow_up.png',
                                                          width: 16,
                                                          height: 16,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _isMoodSelected
                              ? Container(
                                  // height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF101828).withOpacity(0.04),
                                        spreadRadius: 0,
                                        blurRadius: 2.0,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _selectMood('완벽했어요!');
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  _selectedHigh
                                                      ? Color(0xFFECEEFF)
                                                      : Color(0xFFECECF0),
                                                ),
                                              ),
                                              icon: SvgPicture.asset(
                                                _selectedHigh
                                                    ? 'assets/icons/my-mood/high-fill.svg'
                                                    : 'assets/icons/my-mood/high.svg',
                                                width: 20,
                                                height: 20,
                                                color: _selectedHigh
                                                    ? Color(0xFF6046FF)
                                                    : Color(0xFF667086),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _selectMood('괜찮았어요!');
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  _selectedMid
                                                      ? Color(0xFFECEEFF)
                                                      : Color(0xFFECECF0),
                                                ),
                                              ),
                                              icon: SvgPicture.asset(
                                                _selectedMid
                                                    ? 'assets/icons/my-mood/mid-fill.svg'
                                                    : 'assets/icons/my-mood/mid.svg',
                                                width: 20,
                                                height: 20,
                                                color: _selectedMid
                                                    ? Color(0xFF6046FF)
                                                    : Color(0xFF667086),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _selectMood('아쉬워요!');
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  _selectedLow
                                                      ? Color(0xFFECEEFF)
                                                      : Color(0xFFECECF0),
                                                ),
                                              ),
                                              icon: SvgPicture.asset(
                                                _selectedLow
                                                    ? 'assets/icons/my-mood/low-fill.svg'
                                                    : 'assets/icons/my-mood/low.svg',
                                                width: 20,
                                                height: 20,
                                                color: _selectedLow
                                                    ? Color(0xFF6046FF)
                                                    : Color(0xFF667086),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                            bottom: 16, right: 10),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: 80,
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            child: TextField(
                                              focusNode: _textFocus,
                                              controller: _controller,
                                              maxLength: _maxLength,
                                              maxLines: _controller.text.isEmpty
                                                  ? 6
                                                  : null,
                                              decoration: InputDecoration(
                                                hintText: _selectedMood,
                                                hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF8892A6),
                                                ),
                                                alignLabelWithHint: true,
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                ),
                                                counterText:
                                                    '$_characterCount/$_maxLength',
                                                counterStyle: TextStyle(
                                                  fontSize: 12,
                                                  height: 2,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF8892A6),
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Color(0xFF14161A),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              onChanged: (text) {
                                                _updateCharacterCount();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Consumer<PhotoManagerProvider>(
                                        builder:
                                            (context, photoManager, child) {
                                          return photoManager
                                                  .selectedImageList.isNotEmpty
                                              ? PhotoDisplayWidget(
                                                  photoImageList: photoManager
                                                      .selectedImageList,
                                                )
                                              : SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF101828).withOpacity(0.04),
                                        spreadRadius: 0,
                                        blurRadius: 2.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Text(
                                          '목표 달성 만족도는 어땠나요?',
                                          style: TextStyle(
                                            color: Color(0xFF14161A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      WidgetStateProperty.all<
                                                          Color>(
                                                    Colors.transparent,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _selectMood('완벽했어요!');
                                                },
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/my-mood/high.svg',
                                                      width: 30,
                                                      height: 30,
                                                      fit: BoxFit.cover,
                                                      color: Color(0xFF667086),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '완벽했어요!',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF667086),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      WidgetStateProperty.all<
                                                          Color>(
                                                    Colors.transparent,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _selectMood('괜찮았어요!');
                                                },
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/my-mood/mid.svg',
                                                      width: 30,
                                                      height: 30,
                                                      fit: BoxFit.cover,
                                                      color: Color(0xFF667086),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '괜찮았어요!',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF667086),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      WidgetStateProperty.all<
                                                          Color>(
                                                    Colors.transparent,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _selectMood('아쉬워요!');
                                                },
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/my-mood/low.svg',
                                                      width: 30,
                                                      height: 30,
                                                      fit: BoxFit.cover,
                                                      color: Color(0xFF667086),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '아쉬워요!',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF667086),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFECECF0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        left: 16,
                      ),
                      child: photoManager.assets.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xFFECECF0),
                                ),
                                child: IconButton(
                                  onPressed: photoManager.checkPermission,
                                  icon: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Color(0xFF5C42FF),
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          : photoManager.isLoading
                              ? Container() // 이미지 로딩 중
                              : SizedBox(
                                  height: 48,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: photoManager.assets.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == photoManager.assets.length) {
                                        // 마지막 인덱스에는 버튼을 추가
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color(0xFFECECF0),
                                          ),
                                          child: IconButton(
                                            onPressed: () =>
                                                showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16)),
                                              ),
                                              builder: (context) =>
                                                  AlbumSelectView(),
                                            ),
                                            icon: Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              color: Color(0xFF5C42FF),
                                              size: 24,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            if (photoManager.selectedImageList
                                                        .length >
                                                    12 &&
                                                !photoManager.isSelected) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '최대 12개의 사진만 선택할 수 있습니다'),
                                                ),
                                              );
                                              return;
                                            }
                                            photoManager.toggleSelection(index);
                                          },
                                          child: Stack(
                                            fit: StackFit
                                                .expand, // 자식 위젯이 부모 크기에 맞게 확장
                                            children: [
                                              ThumbnailWidget(
                                                  asset: photoManager
                                                      .assets[index]),
                                              if (photoManager.selectedList[
                                                  index]) // 선택 상태일 때 체크 UI 추가
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(
                                                            0.4), // 반투명 오버레이
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
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
