import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/providers/provider.dart';
import 'package:mogrow/screens/layout/splash_screen.dart';
import 'package:mogrow/screens/router/locations.dart';
import 'package:mogrow/services/background_task_service.dart';
import 'package:mogrow/services/notification_manager.dart';
import 'package:mogrow/services/notification_scheduler.dart';
import 'package:provider/provider.dart';

// 비머 전역 선언
// final _routerDelegate = BeamerDelegate(
//   // 비머 가드 (로그인 기능 추가 시 -> 리다이렉션)
//   // guards: [
//   //   BeamGuard(
//   //     pathBlueprints: ['/'],
//   //     check: (context, location) {
//   //       return true;
//   //     },
//   //     showPage: BeamPage(
//   //       child: AuthScreen(),
//   //     ),
//   //   ),
//   // ],

//   locationBuilder: BeamerLocationBuilder(
//     beamLocations: [
//       MainLocation(), // 메인 페이지
//       AddTodoLocation(), // 새로운 할일 페이지

//       // 기록 관련
//       RecordSurveyLocation(),
//       RecordSurveyUpdateLocation(),
//     ],
//   ),
// );

// 라우터 설정
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    MainLocation.route, // 메인 페이지

    HomeLocation.route,
    AddTodoLocation.route, // 새로운 할일 페이지
    UpdateTodoLocation.route, // update

    // 기록
    RecordLocation.route,
    RecordSurveyLocation.route, // 기록 설문 화면
    RecordSurveyDetailLocation.route,
    RecordSurveyUpdateLocation.route, // 기록 수정 화면

    // 달성
    AchieveLocation.route,
    AchieveDetailLocation.route,

    // 검색
    RecordSearchLocation.route,
  ],
);

void main() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFE5E5E5),
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

  try {
    // 알림 초기화
    print('🚀 Initializing notifications...');

    // 1. 기본 알림 설정 (시간 기반: 08:00, 21:00)
    await NotificationManager().setupAllNotifications();

    if (Platform.isIOS) {
      await NotificationScheduler.calculateTomorrowNotifications();
      await NotificationManager().scheduleStoredNotifications();
    } else {
      // 2. 백그라운드 작업 초기화 (밤 11시에 내일 알림 계산)
      print('🚀 Initializing background tasks...');
      await BackgroundTaskService.initialize();
      await NotificationManager().scheduleStoredNotifications();
    }

    // 앱 시작 시 마지막 접속 시간 업데이트
    await NotificationManager().updateLastLoginTime();

    // 예약된 알림 확인 (디버깅용)
    await NotificationManager().printPendingNotifications();

    print('✅ App initialization completed');
  } catch (e) {
    print('❌ Initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: ProviderList.providers,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 목표 초기화 완료 + 최소 스플래시 2초 동시 대기
    final goalProvider = Provider.of<GoalListProvider>(context, listen: false);
    final initFuture = Future.wait<void>([
      Future.delayed(const Duration(seconds: 2)),
      goalProvider.ready,
    ]);

    return FutureBuilder<Object>(
      future: initFuture,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 900), // 페이드인아웃 효과
          child: _splashLoadingWidget(snapshot), // 스냅샷실행 위젯 지정
        );
      },
    );
  }

  Widget _splashLoadingWidget(AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Material(
        child: Center(child: Text('초기화 중 오류가 발생했습니다.')),
      );
    }
    if (snapshot.hasData) {
      return const App();
    }
    return const SplashScreen();
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
      // routeInformationParser: _router.routeInformationParser,
      // routeInformationProvider: _router.routeInformationProvider,
      // routerDelegate: _router.routerDelegate,
      routerConfig: _router,
      // locale: Locale('ko', 'KR'),
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
