import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:momentum/model/image/image_model.dart';
import 'package:momentum/providers/navigation/bottom_navigation_provider.dart';
import 'package:momentum/providers/provider.dart';
import 'package:momentum/screens/achieve/achieve_screen.dart';
import 'package:momentum/screens/bottom/bottom_screen.dart';
import 'package:momentum/screens/home/home_screen.dart';
import 'package:momentum/screens/splash/splash_screen.dart';
import 'package:momentum/widgets/navigation_bar_widget.dart';
import 'package:momentum/widgets/navigation_body_widget.dart';
import 'package:momentum/screens/record/record_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: Future.delayed(Duration(seconds: 3), () => 100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 900), // 페이드인아웃 효과
          child: _splashLodingWidget(snapshot), // 스냅샷실행 위젯 지정
        );
      },
    );
  }

  StatelessWidget _splashLodingWidget(AsyncSnapshot<Object> snapshot) {
    if (snapshot.hasError) {
      print('에러 발생');
      return Text('Error');
    } else if (snapshot.hasData) {
      return App();
    } else {
      return SplashScreen();
    }
  }
}

// App 위젯
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //디버그 배너 해제
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
      //   child: Scaffold( // 화면 구성 및 구조에 관한 것
      //     backgroundColor: Colors.white,
      //     body: TabBarView(
      //       children: [
      //         HomeScreen(),
      //         RecordScreen(),
      //         AchieveScreen(),
      //       ],
      //     ),
      //     bottomNavigationBar: BottomScreen(),
      //   ),
      // ),
      home: MultiProvider(
        // provider 사용
        providers: AppProviders.providers,
        child: Scaffold(
          body: NavigationBodyWidget(), // App 위젯의 바디 부분 위젯
          bottomNavigationBar: NavigationBarWidget(), // App 위젯의 바텀 네비게이션 바 부분 위젯
        ), // 화면에 보여지는 부분
      ),
    );
  }
}
