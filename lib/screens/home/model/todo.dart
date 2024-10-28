import 'package:flutter/material.dart';

class Todo {
  int? id; // Todo 항목의 고유 식별자
  String title; // Todo의 내용
  String gemstone;
  String repeat;
  bool status;
  bool isCompleted;
  bool isContinue;
  DateTime date;

  // 생성자
  Todo(
      {this.id,
      required this.title,
      required this.gemstone,
      required this.repeat,
      required this.status,
      required this.isCompleted,
      required this.isContinue,
      required this.date});

  // Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id, // id 필드
      'title': title, // content 필드
      'gemstone': gemstone, // content 필드
      'repeat': repeat, // content 필드
      'status': status, // content 필드
      'isCompleted': isCompleted, // content 필드
      'isContinue': isContinue, // content 필드
      'date': date, // content 필드
    };
  }
}

class TodoListModel with ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners(); // UI에 변경 사항 알리기
  }

  // 다른 메서드 추가 가능 (예: 삭제, 업데이트 등)
}

/* 
DateTime(2024, 10, 20): [
        {
          'title': '보석 아이콘 제작',
          'gemstone': 'sunstone',
          'repeat': null,
          'status': false,
          'isCompleted': false,
          'isContinue': false,
        },
        {
          'title': '엣지 케이스 그리기',
          'gemstone': 'sphene',
          'repeat': '매월 마지막 주 화요일',
          'status': false,
          'isCompleted': false,
          'isContinue': false,
        },
      ],
      DateTime(2024, 10, 15): [
        {
          'title': '디자인에 플로우 적용 후 놓친 것 다시 하기',
          'gemstone': 'aquamarine',
          'repeat': "매주 화요일",
          'status': false,
          'isCompleted': false,
          'isContinue': false,
        },
        {
          'title': '디자인 시스템 구축',
          'gemstone': 'amethyst',
          'repeat': null,
          'status': true,
          'isCompleted': false,
          'isContinue': false,
        },
      ],
 */