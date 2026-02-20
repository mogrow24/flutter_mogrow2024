import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mogrow/providers/photo_manager.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/record/components/album_select_view.dart';
import 'package:mogrow/screens/record/components/show_modal_update.dart';
import 'package:provider/provider.dart';

class RecordSurveyUpdate extends StatefulWidget {
  const RecordSurveyUpdate({super.key});

  @override
  State<RecordSurveyUpdate> createState() => _RecordSurveyUpdateState();
}

class _RecordSurveyUpdateState extends State<RecordSurveyUpdate> {
  late TextEditingController _controller = TextEditingController();
  int _characterCount = 0;
  final int _maxLength = 1000;
  final FocusNode _textFocus = FocusNode();

  // 사진 형태
  int _selected = 0;

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _controller.text.length;
    });
  }

  // 카메라 선택 모달
  Future<void> pickImages(BuildContext context) async {
    try {
      // final List<Asset> resultList = await MultiImagePicker.pickImages(
      //   maxImages: 12,
      //   enableCamera: true,
      // );
      // print(resultList);
      // final t = Provider.of<MultiImagePicker>(context, listen: false);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 초기화
      context.read<PhotoManagerProvider>().clearData();

      // 넘겨 받은 데이터
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
      final record = extra['record'];
      final imageList = extra['imageList'];

      context.read<PhotoManagerProvider>().setSelectedImageList(imageList);

      _selectMood(record.surveyMood);
      _controller = TextEditingController(text: record.surveyComment);
      _characterCount = _controller.text.length;
    });
  }

  // Accordion 관련
  bool _isExpanded = false;

  // 만족도 선택 관련
  bool _selectedHigh = false;
  bool _selectedMid = false;
  bool _selectedLow = false;
  String _selectedMood = '';

  void _selectMood(String mood) {
    setState(() {
      if (mood == 'high') {
        _selectedHigh = true;
        _selectedMid = false;
        _selectedLow = false;
        _selectedMood =
            '오늘을 완벽한 하루로 만든 비결은 무엇이었나요? 그 순간의 기쁨, 달성감, 그리고 오늘 하루를 돌아볼 때 미소 짓게 하는 모든 것들에 대해 자세히 적어보세요.\n작은 매일의 기록들은 나중에 더 큰 영감을 줄 거예요.';
      } else if (mood == 'mid') {
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

  // 카메라 선택 모달
  void _modalPopup() {}

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoListProvider>(context);
    final recordProvider = Provider.of<RecordListProvider>(context);

    // 사진 상태관리
    final photoManager = context.watch<PhotoManagerProvider>();

    // 비머로 넘겨 받은 데이터
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final record = extra['record'];
    final todoList = extra['todoList'];
    final title = extra['title'];
    final gemstone = extra['gemstone'];
    final selectedDay = extra['selectedDay'];
    final goalId = extra['goalId'];

    // 화면 드롭다운에
    // final todoList = todoProvider.getListByGoalId(goalId, selectedDay);
    // final record = recordProvider.record;

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
            context.pop(false);
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

                    final type = await showDialog(
                      context: context,
                      builder: (context) =>
                          ShowModalUpdate(selectedDay: selectedDay),
                    );

                    if (type == 'update') {
                      // record update
                      await recordProvider.updateRecordById(
                          record.recordId,
                          mood,
                          _controller.text,
                          photoManager.selectedImageList);

                      if (mounted) context.pop(true);
                    }
                  }
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  '수정하기',
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
                                                                            18,
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
                          Container(
                            // height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF101828).withOpacity(0.04),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _selectMood('high');
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
                                          _selectMood('mid');
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
                                          _selectMood('low');
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
                                  padding:
                                      EdgeInsets.only(bottom: 16, right: 10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: 80,
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: TextField(
                                        focusNode: _textFocus,
                                        controller: _controller,
                                        maxLength: _maxLength,
                                        maxLines:
                                            _controller.text.isEmpty ? 6 : null,
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
                                photoManager.selectedImageList.isNotEmpty
                                    ? Column(
                                        children: [
                                          _selected == 0
                                              ? buildGridView(
                                                  photoManager
                                                      .selectedImageList,
                                                )
                                              : SizedBox(
                                                  height: 160,
                                                  child: buildListView(
                                                      photoManager
                                                          .selectedImageList),
                                                ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: 20,
                                              left: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_selected == 0) {
                                                        _selected = 1;
                                                      } else {
                                                        _selected = 0;
                                                      }
                                                    });
                                                  },
                                                  style: TextButton.styleFrom(
                                                    // padding: EdgeInsets
                                                    //     .symmetric(
                                                    //   vertical: 10,
                                                    //   horizontal: 15,
                                                    // ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    overlayColor:
                                                        Colors.transparent,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        _selected == 0
                                                            ? 'assets/icons/grid.svg'
                                                            : 'assets/icons/carousel.svg',
                                                        width: 20,
                                                        height: 20,
                                                        color:
                                                            Color(0xFF3E4450),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 1,
                                                          left: 4,
                                                        ),
                                                        child: Text(
                                                          _selected == 0
                                                              ? "앨범형"
                                                              : "가로형",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF3E4450),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "${photoManager.selectedImageList.length}/12",
                                                  style: TextStyle(
                                                    color: Color(0xFF8892A6),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink(),
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
                                  icon: Image.asset(
                                    'assets/icons/add_photo.png',
                                    width: 24,
                                    height: 24,
                                    color: Color(0xFF5C42FF),
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
                                            icon: Image.asset(
                                              'assets/icons/add_photo.png',
                                              width: 24,
                                              height: 24,
                                              color: Color(0xFF5C42FF),
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
                                              FutureBuilder<Uint8List?>(
                                                future: photoManager
                                                    .assets[index]
                                                    .thumbnailData, // 썸네일 데이터 가져오기
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot.hasData) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.memory(
                                                        snapshot.data!,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Icon(Icons.error),
                                                    );
                                                  }
                                                },
                                              ),
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

Widget buildGridView(list) {
  int cnt = list.length == 1
      ? 1
      : list.length == 2
          ? 2
          : 3;

  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: cnt,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
    ),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (context, index) {
      final photoManager = context.read<PhotoManagerProvider>();
      final asset = list[index];

      return FutureBuilder<Uint8List?>(
        future: asset.thumbnailData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Container(
              width: 60,
              height: 60,
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
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        photoManager.removeSelectedImage(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF).withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF667086),
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Icon(Icons.error),
            );
          }
        },
      );
    },
  );
}

Widget buildListView(list) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final photoManager = context.read<PhotoManagerProvider>();
        final asset = list[index];

        return FutureBuilder<Uint8List?>(
          future: asset.thumbnailData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return Container(
                width: 160,
                height: 160,
                margin: EdgeInsets.symmetric(horizontal: 1),
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
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          photoManager.removeSelectedImage(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF).withOpacity(0.6),
                            shape: BoxShape.circle,
                            // border: Border.all(
                            //   color: Color(0xFFFFFFFF),
                            //   width: 1,
                            // ),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            color: Color(0xFF667086),
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Icon(Icons.error),
              );
            }
          },
        );
      },
    ),
  );
}
