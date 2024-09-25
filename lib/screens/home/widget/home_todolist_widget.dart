import 'package:flutter/material.dart';
import 'package:mogrow/screens/home/widget/add_todolist_widget.dart';
import 'package:mogrow/widget/show_modal_add_goal.dart';
import 'package:mogrow/widget/show_modal_select_goal.dart';

class HomeTodolistWidget extends StatefulWidget {
  final List<Map<String, dynamic>> todoList;

  const HomeTodolistWidget({super.key, required this.todoList});

  @override
  State<HomeTodolistWidget> createState() => _HomeTodolistWidgetState();
}

class _HomeTodolistWidgetState extends State<HomeTodolistWidget> {
  // final List<String> todoList = [
  //   '보석 아이콘 제작',
  //   '엣지 케이스 그리기',
  //   '디자인에 플로우 적용 후 놓친 것 다시 하기',
  //   '디자인 시스템 구축',
  // ];

  @override
  void initState() {
    super.initState();
    print(widget.todoList);
  }

  fn(value) {
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color(0xffF6F6F8),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.sort,
                              size: 16,
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
                child: widget.todoList.isEmpty
                    ? Center(
                        child: Text(
                          '아직 할 일이 없어요.',
                          style: TextStyle(
                            color: Color(0xFF8892A6),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : ListView.builder(
                        // padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: widget.todoList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Dismissible(
                                direction: DismissDirection.endToStart,
                                key: Key(widget.todoList[index]['title']),
                                onDismissed: (direction) {
                                  setState(() {
                                    widget.todoList.removeAt(index);
                                  });
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF04438),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // color: Color(0xFFF04438),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 13),
                                    child: ImageIcon(
                                      size: 20,
                                      color: Colors.white,
                                      AssetImage(
                                        'assets/icons/delete.png',
                                      ),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFECECF0),
                                      width: 1,
                                    ),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Checkbox(
                                        value: true,
                                        fillColor: WidgetStatePropertyAll(
                                          Color(0xFF0066FA),
                                        ),
                                        splashRadius: 24,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        onChanged: (value) {
                                          fn(value);
                                          value = true;
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.todoList[index]['title'],
                                          style: TextStyle(
                                            color: Color(0xFF14161A),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        icon: Image.asset(
                                            'assets/icons/gemstones/core.png'),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ShowModal();
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
