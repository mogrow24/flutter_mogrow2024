import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/record/components/custom_grid_view.dart';
import 'package:mogrow/screens/record/components/custom_list_view.dart';
import 'package:mogrow/screens/record/components/layout_pdf_widget.dart';
import 'package:mogrow/screens/record/components/show_modal_delete.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class RecordSurveyDetail extends StatefulWidget {
  const RecordSurveyDetail({super.key});

  @override
  State<RecordSurveyDetail> createState() => _RecordSurveyDetailState();
}

class _RecordSurveyDetailState extends State<RecordSurveyDetail> {
// Accordion 관련
  bool _isExpanded = false;

  // bool _isInitialized = false;

  // 사진 형태
  int _selected = 0;

  // loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 넘겨 받은 데이터
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
      final goalId = extra['goalId'];
      final selectedDay = extra['selectedDay'];

      await context
          .read<RecordListProvider>()
          .getRecordByGoalIdAndDate(goalId, selectedDay);
      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // pdf 추출
  Future<void> _exportModifiedPdf(
    List<Todo> todoList,
    String title,
    Record record,
    int completedCnt,
    int listCnt,
    List<RecordsImage> imageList,
    String gemstone,
  ) async {
    try {
      // 1. 캡처용 컨트롤러 (화면에 붙은 컨트롤러와 별개로 사용 가능)
      final pdfScreenshotController = ScreenshotController();

      // 1. 한글 폰트 로드
      final fontData =
          await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
      final myFont = pw.Font.ttf(fontData);

      // 2. PDF 문서 생성 시 테마에 폰트를 박아버립니다.
      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: myFont,
          bold: myFont,
          italic: myFont,
          // fallback은 폰트에 해당 글자가 없을 때 대비책입니다.
          fontFallback: [myFont],
        ),
      );

      // --- 1. 데이터 분할 조건 체크 ---
      // 투두리스트가 10개 넘으면서 코멘트 길이가 1000자가 넘으면 -> 이미지는 그냥 2페이지로 다 넘기기
      // 둘다 해당이 안되더라도 이미지 리스트는 3개가 넘으면 2페이지로 넘겨야함.
      bool isSecondPageNeeded = imageList.isNotEmpty;

      int totalPages = isSecondPageNeeded ? 2 : 1;

      // --- 2. 각 페이지별 캡처 및 PDF 추가 ---
      for (int i = 0; i < totalPages; i++) {
        final Uint8List imageBytes =
            await pdfScreenshotController.captureFromWidget(
          LayoutPdfWidget(
              todoList: todoList,
              title: title,
              completedCnt: completedCnt,
              listCnt: listCnt,
              record: record,
              imageList: i == 0 ? [] : imageList,
              gemstone: gemstone,
              pageNumber: i + 1, // 현재 페이지 번호 전달
              isSecondPageNeeded: isSecondPageNeeded,
              currentPage: i + 1,
              totalPage: totalPages),
          delay: const Duration(milliseconds: 300),
          pixelRatio: 2.0,
          context: context,
        );

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.only(
              top: 70,
              bottom: 40,
              left: 0,
              right: 0,
            ),
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name:
            '$title (${record.createDate!.year}${record.createDate!.month}${record.createDate!.day}).pdf',
      );
    } catch (e) {
      print("PDF 에러: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // final todoProvider = Provider.of<TodoListProvider>(context, listen: false);
    final todoProvider = context.watch<TodoListProvider>();
    // final goalProvider = Provider.of<GoalListProvider>(context, listen: false);
    final recordProvider = context.watch<RecordListProvider>();

    // 넘겨 받은 데이터
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final title = extra['title'];
    final gemstone = extra['gemstone'];
    final selectedDay = extra['selectedDay'];
    final goalId = extra['goalId'];

    final todoList = todoProvider.getListByGoalId(goalId, selectedDay);

    if (recordProvider.record == null) return SizedBox.shrink();
    final record = recordProvider.record!;
    final imageList = recordProvider.imageList;

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
            context.pop(true);
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
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              position: PopupMenuPosition.under,
              color: Color(0xFFFFFFFF),
              constraints: const BoxConstraints(
                minWidth: 130,
                maxWidth: 150,
                maxHeight: 160,
              ),

              /// 팝업 메뉴의 테두리와 round 처리
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                // 메뉴 아이템 클릭 시 동작
                if (value == 'U') {
                  final updatedRecord = await context.push(
                    '/recordSurveyUpdate',
                    extra: {
                      'record': record,
                      'todoList': todoList,
                      'gemstone': gemstone,
                      'title': title,
                      'selectedDay': selectedDay,
                      'goalId': goalId,
                      'imageList': imageList,
                    },
                  );

                  if (updatedRecord == true) {
                    setState(() {
                      _isLoading = true;
                    });

                    await context
                        .read<RecordListProvider>()
                        .getRecordByGoalIdAndDate(goalId, selectedDay);
                    await Future.delayed(Duration(milliseconds: 500));

                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else if (value == 'D') {
                  final type = await showDialog(
                    context: context,
                    builder: (context) =>
                        ShowModalDelete(selectedDay: selectedDay),
                  );

                  if (type == 'delete') {
                    await recordProvider.deleteRecords(record.recordId);
                    if (mounted) context.pop(true);
                  }
                } else if (value == 'P') {
                  final completedCnt =
                      todoProvider.getCompleltedCnt(goalId, selectedDay);
                  final listCnt =
                      todoProvider.getListCntByGoalId(goalId, selectedDay);
                  _exportModifiedPdf(
                    todoList,
                    title,
                    record,
                    completedCnt,
                    listCnt,
                    imageList,
                    gemstone,
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'U',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 24,
                        color: Color(0xFF667086),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '수정하기',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'D',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 24,
                        color: Color(0xFF667086),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '삭제하기',
                        style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'P',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 24,
                        color: Color(0xFF667086),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'PDF변환하기',
                        style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      body: _isLoading
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3C3C3C),
                ),
              ),
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Color(0xffF6F6F8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
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
                                            color: Color(0xFF101828)
                                                .withOpacity(0.04),
                                            spreadRadius: 0,
                                            blurRadius: 2.0,
                                            offset: Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFF14161A),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                _isExpanded
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
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
                                                            color: Color(
                                                                0xFF5C42FF),
                                                          ),
                                                        ),
                                                      )
                                                    : IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
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
                                                    //   minHeight: 48,
                                                    //   // minWidth: double.infinity,
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 12,
                                                            bottom: 0,
                                                            left: 24,
                                                            right: 24,
                                                          ),
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: 120,
                                                              minHeight: 10,
                                                            ),
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  todoList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final todoItem =
                                                                    todoList[
                                                                        index];

                                                                return Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: 7,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          todoItem.isCompleted
                                                                              ? Icon(
                                                                                  Icons.circle,
                                                                                  size: 7,
                                                                                  color: Color(0xFFBEC4CE),
                                                                                )
                                                                              : Icon(
                                                                                  Icons.circle,
                                                                                  size: 7,
                                                                                ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          todoItem.isCompleted
                                                                              ? Text(
                                                                                  todoItem.title,
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFFBEC4CE),
                                                                                    fontWeight: FontWeight.w400,
                                                                                    fontSize: 15,
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                    decorationColor: Color(0xFFBEC4CE),
                                                                                    decorationThickness: 1,
                                                                                  ),
                                                                                )
                                                                              : Text(
                                                                                  todoItem.title,
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF14161A),
                                                                                    fontWeight: FontWeight.w400,
                                                                                    fontSize: 15,
                                                                                  ),
                                                                                )
                                                                        ],
                                                                      ),
                                                                      todoItem
                                                                              .isCompleted
                                                                          ? Icon(
                                                                              Icons.check,
                                                                              color: Color(0xFF5C42FF),
                                                                              size: 18,
                                                                            )
                                                                          : SvgPicture
                                                                              .asset(
                                                                              'assets/icons/todo/working.svg',
                                                                              width: 16,
                                                                              height: 16,
                                                                              color: Color(0xFF667086),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 2,
                                                          color: Colors.grey,
                                                          thickness: 0.2,
                                                        ),
                                                        SizedBox(
                                                          height: 36,
                                                          child: IconButton(
                                                            style: ButtonStyle(
                                                              overlayColor:
                                                                  WidgetStateProperty
                                                                      .all<
                                                                          Color>(
                                                                Colors
                                                                    .transparent,
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
                                      color:
                                          Color(0xFF101828).withOpacity(0.04),
                                      spreadRadius: 0,
                                      blurRadius: 2.0,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 18,
                                    left: 18,
                                    top: 16,
                                    bottom: 5,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: Color(0xFFE0ECFF),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: SvgPicture.asset(
                                                'assets/icons/my-mood/${record.surveyMood}.svg',
                                                color: Color(0xFF0066FA),
                                                width: 30,
                                                height: 30,
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
                                      SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          // bottom: 0,
                                          right: 10,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 14,
                                                ),
                                                child: Text(
                                                  record.surveyComment,
                                                  style: TextStyle(
                                                    color: Color(0xFF14161A),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              _selected == 0
                                                  ? CustomGridView(
                                                      imageList: imageList,
                                                      type: "surveyDetail",
                                                    )
                                                  : SizedBox(
                                                      height: 160,
                                                      child: CustomListView(
                                                        imageList: imageList,
                                                        type: "surveyDetail",
                                                      ),
                                                    ),
                                              imageList.isEmpty
                                                  ? SizedBox.shrink()
                                                  : TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (_selected == 0) {
                                                            _selected = 1;
                                                          } else {
                                                            _selected = 0;
                                                          }
                                                        });
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
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
                                                            color: Color(
                                                                0xFF3E4450),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                ],
              ),
            ),
    );
  }
}
