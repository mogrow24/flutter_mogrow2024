import 'package:flutter/material.dart';
import 'package:momentum/screens/home/widget/add_todolist_widget.dart';

class HomeTodolistWidget extends StatelessWidget {
  const HomeTodolistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color(0xffF6F6F8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Padding(
                padding: const EdgeInsets.only(
                    top: 4, right: 4, bottom: 4, left: 12),
                child: Container(
                  // color: Color(0xFFFFFFFF),
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
                        color: Color(0xFF101828).withOpacity(0.04),
                        spreadRadius: 0,
                        blurRadius: 2.0,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Checkbox(
                      //   value: false,
                      //   onChanged: (true) {
                      //     print('1'),
                      //   },
                      // ),
                      Text(
                        'Morbi facilisis',
                        style: TextStyle(
                          color: Color(0xFF14161A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: 200,
              // ),
              // AddTodolistWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
