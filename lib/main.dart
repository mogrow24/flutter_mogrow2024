import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // or CupertinoApp(ios)
      home: Scaffold( // 화면 구성 및 구조에 관한 것 (appBar or body)
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('상단바'),
        ),
        body: Center(
          child: Text('contents'),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              // IconButton(
              //     onPressed: () {
              //
              //     },
              //     icon: SvgPicture.asset(
              //       'assets/icons/home.svg',
              //     ),
              //     iconSize: 160,
              // ),
              Icon(Icons.star),
              Icon(Icons.star),
              Icon(Icons.star)
            ],
          ),
        ),
      ),
    );
  }
}