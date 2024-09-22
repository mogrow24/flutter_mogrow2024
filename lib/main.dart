import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // or CupertinoApp(ios)
      home: Scaffold( // 화면 구성 및 구조에 관한 것 (appBar or body)
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Hello World!'),
        ),
        body: Center(
          child: Text('Hello World!!'),
        ),
      ),
    );
  }
}