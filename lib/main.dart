import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mogrow/screens/auth/auth_screen.dart';
import 'package:mogrow/screens/router/locations.dart';
import 'package:mogrow/screens/start/splash_screen.dart';

// 비머 전역 선언
final _routerDelegate = BeamerDelegate(
  // 비머 가드
  guards: [
    BeamGuard(
      pathBlueprints: ['/'],
      check: (context, location) {
        return true;
      },
      showPage: BeamPage(
        child: AuthScreen(),
      ),
    ),
  ],

  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      MainLocation(), // 메인 페이지
      AddTodoLocation(), // 새로운 할일 페이지
    ],
  ),
);

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      //디버그 배너 해제
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
      title: "mogrow",
      theme: ThemeData(
        fontFamily: 'NotoSans',
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
