import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:mogrow/screens/home/components/show_modal_orderby.dart';
import 'package:mogrow/screens/home/widget/todo_list_widget.dart';
import 'package:provider/provider.dart';

class HomeTodolistWidget extends StatefulWidget {
  final DateTime selectedDay;

  const HomeTodolistWidget({super.key, required this.selectedDay});

  @override
  State<HomeTodolistWidget> createState() => _HomeTodolistWidgetState();
}

class _HomeTodolistWidgetState extends State<HomeTodolistWidget> {
  // 내일로 관련
  // String? formattedTomorrow;

  // 정렬 모달
  int? selectedArrangeIndex = 0;
  void showOrderByModal() async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShowModalOrderby(initialCheckedIndex: selectedArrangeIndex);
        });

    if (result != null) {
      setState(() {
        selectedArrangeIndex = result['checkedIndex'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);

    final List<Todo> todoList = provider.dateTodoList[widget.selectedDay] ?? [];

    if (selectedArrangeIndex == 0) {
      todoList.sort((a, b) => b.id.compareTo(a.id)); // 최신순 (내림차순)
    } else if (selectedArrangeIndex == 1) {
      todoList.sort((a, b) => a.title.compareTo(b.title)); // 이름순 (오름차순)
    } else if (selectedArrangeIndex == 2) {
      todoList.sort((a, b) => b.gemstone.compareTo(a.gemstone)); // 목표순 (오름차순)
    }

    return Expanded(
      child: Container(
        color: Color(0xffF6F6F8),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '나의 오늘',
                      style: TextStyle(
                        color: Color(0xff3E4450),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showOrderByModal();
                      },
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.sort,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '정렬',
                              style: TextStyle(
                                color: Color(0xff3E4450),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                // color: Color(0xFFFFFFFF),
                child: todoList.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Center(
                              child: Text(
                                '아직 할 일이 없어요.',
                                style: TextStyle(
                                  color: Color(0xFF8892A6),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : TodoListWidget(
                        selectedDay: widget.selectedDay,
                        todoList: todoList,
                      ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
