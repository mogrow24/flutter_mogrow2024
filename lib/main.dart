import 'package:flutter/material.dart';
import 'package:momentum/model/image/image_model.dart';
import 'package:momentum/providers/navigation/bottom_navigation_provider.dart';
import 'package:momentum/screens/achieve/achieve_screen.dart';
import 'package:momentum/screens/bottom/bottom_screen.dart';
import 'package:momentum/screens/home/home_screen.dart';
import 'package:momentum/screens/home/widget/navigation_bar_widget.dart';
import 'package:momentum/screens/home/widget/navigation_body_widget.dart';
import 'package:momentum/screens/record/record_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//디버그 배너 해제
      title: "momentum",
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
      ),
      // home: DefaultTabController(
      //   length: 4,
      //   child: Scaffold( // 화면 구성 및 구조에 관한 것 (appBar or body)
      //     backgroundColor: Colors.white,
      //     body: TabBarView(
      //       children: [
      //         HomeScreen(),
      //         RecordScreen(),
      //         AchieveScreen(),
      //       ],
      //     ),
      //     extendBodyBehindAppBar: true, // add this line
      //
      //     bottomNavigationBar: BottomScreen(),
      //   ),
      // ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => BottomNavigationProvider())
        ],
        child: App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationBodyWidget(),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
