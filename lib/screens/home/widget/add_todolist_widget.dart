import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:provider/provider.dart';

class AddTodolistWidget extends StatefulWidget {
  final ValueChanged<bool> onFocusChanged;
  final DateTime selectedDay;

  const AddTodolistWidget(
      {super.key, required this.onFocusChanged, required this.selectedDay});

  @override
  State<AddTodolistWidget> createState() => _AddTodolistWidgetState();
}

class _AddTodolistWidgetState extends State<AddTodolistWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  bool _isFocused = false;
  bool _hasText = false;

  // 버튼
  final GlobalKey _iconButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  // 텍스트 필드 포커스 감지
  void handleFocusChange() {
    widget.onFocusChanged(_focusNode.hasFocus);
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  // 텍스트 입력 감지
  void handleTextChange() {
    setState(() {
      _hasText = _textController.text.isNotEmpty;
    });
  }

  // 포커스를 잃을 때 리스너 제거
  void removeListeners() {
    _focusNode.removeListener(handleFocusChange);
    _textController.removeListener(handleTextChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  bool _isTapOnIconButton(PointerEvent event) {
    // IconButton의 RenderBox 가져오기
    final RenderBox renderBox =
        _iconButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Rect buttonRect = position & renderBox.size;

    return buttonRect.contains(event.position);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context, listen: false);

    return Stack(
      children: [
        if (_isFocused)
          Container(
            color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  // width: MediaQuery.of(context).size.width * 0.73,
                  decoration: BoxDecoration(
                    color: Color(0xFFECECF0),
                    border: Border.all(
                      color: Color(0xFFE2E2EA),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    onTapOutside: (event) {
                      // print("포커스 해제!");
                      if (_isTapOnIconButton(event)) {
                        return;
                      }
                      _focusNode.unfocus();
                      removeListeners();
                      widget.onFocusChanged(!_focusNode.hasFocus);
                      setState(() {
                        _isFocused = !_focusNode.hasFocus;
                      });
                    },
                    onTap: () {
                      // print("텍스트 필드 포커스!");
                      // 포커스가 잡혔을 때 리스너를 추가
                      if (!_focusNode.hasFocus) {
                        _focusNode.addListener(handleFocusChange);
                        _textController.addListener(handleTextChange);
                      }
                    },
                    onChanged: (value) {
                      // print(value);
                    },
                    decoration: InputDecoration(
                      hintText: '할 일을 추가해 보세요.',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8892A6),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 10), // Adjust padding as needed
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              _isFocused
                  ? IconButton(
                      key: _iconButtonKey,
                      padding: EdgeInsets.all(12),
                      onPressed: _hasText
                          ? () async {
                              if (_hasText) {
                                String title = _textController.text;
                                // print(widget.selectedDay);

                                // 아이디 생성
                                final customId = await provider
                                    .getNextCustomId(widget.selectedDay);

                                if (title.isNotEmpty) {
                                  final newTodo = Todo(
                                    id: customId,
                                    goalId: "0000000000",
                                    title: title,
                                    gemstone: 'core',
                                    goalTitle: '없음',
                                    repeat: '반복 안함',
                                    repeatCode: "0",
                                    repeatGroupId: null,
                                    status: false,
                                    isCompleted: false,
                                    isContinue: false,
                                    date: widget.selectedDay,
                                  );
                                  provider.addTodo(newTodo);

                                  // 텍스트 필드를 초기화하여 새로운 메모를 입력하기 위해 준비
                                  _textController.clear();

                                  _focusNode.unfocus();
                                  // FocusScope.of(context).unfocus();

                                  // 화면을 다시 그리도록 setState 호출하여 메모 목록을 갱신
                                  setState(() {
                                    // todos = dbHelper.getTodos();
                                  });
                                }
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          _hasText ? Color(0xFF0066FA) : Color(0xFF94BEFF),
                        ),
                      ),
                      icon: Icon(
                        Icons.check,
                        color: Color(0xFFFFFFFF),
                        size: 24,
                      ),
                    )
                  : IconButton(
                      key: _iconButtonKey,
                      padding: EdgeInsets.all(12),
                      onPressed: () {
                        // _focusNode.unfocus();
                        context.push(
                          '/addTodo',
                          extra: {
                            'selectedDay': widget.selectedDay.toIso8601String()
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xFF0066FA),
                        ),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: Color(0xFFFFFFFF),
                        size: 24,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

// class _AddTodolistWidgetState extends State<AddTodolistWidget> {
//   final FocusNode _focusNode = FocusNode();
//   OverlayEntry? _overlayEntry;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_handleFocusChange);
//   }
//
//   @override
//   void dispose() {
//     _focusNode.removeListener(_handleFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   void _handleFocusChange() {
//     if (_focusNode.hasFocus) {
//       _showOverlay();
//     } else {
//       _removeOverlay();
//     }
//   }
//
//   void _showOverlay() {
//     _overlayEntry = _createOverlayEntry();
//     Overlay.of(context)?.insert(_overlayEntry!);
//   }
//
//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//
//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;
//     var offset = renderBox.localToGlobal(Offset.zero);
//
//     return OverlayEntry(
//       builder: (context) => GestureDetector(
//         onTap: () {
//           _focusNode.unfocus();
//         },
//         child: Stack(
//           children: [
//             Container(
//               color: Colors.black.withOpacity(0.5),
//             ),
//             Positioned(
//               left: offset.dx,
//               top: offset.dy,
//               width: size.width,
//               height: size.height,
//               child: Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFECECF0),
//                     border: Border.all(
//                       color: Color(0xFFE2E2EA),
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(35),
//                   ),
//                   child: TextField(
//                     focusNode: _focusNode,
//                     decoration: InputDecoration(
//                       hintText: '할 일을 추가해 보세요.',
//                       hintStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFF8892A6),
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.only(
//                           left: 15, bottom: 10), // Adjust padding as needed
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//       child: Container(
//         height: 42,
//         width: MediaQuery.of(context).size.width * 0.8,
//         decoration: BoxDecoration(
//           color: Color(0xFFECECF0),
//           border: Border.all(
//             color: Color(0xFFE2E2EA),
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(35),
//         ),
//         child: TextField(
//           focusNode: _focusNode,
//           decoration: InputDecoration(
//             hintText: '할 일을 추가해 보세요.',
//             hintStyle: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF8892A6),
//             ),
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.only(left: 15, bottom: 10),
//           ),
//         ),
//       ),
//     );
//   }
// }
