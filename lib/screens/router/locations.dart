import 'package:go_router/go_router.dart';
import 'package:mogrow/screens/achieve/achieve_screen.dart';
import 'package:mogrow/screens/achieve/widget/achieve_detail.dart';
import 'package:mogrow/screens/achieve/widget/record_search.dart';
import 'package:mogrow/screens/home/home_screen.dart';
import 'package:mogrow/screens/home/widget/add_todo_widget.dart';
import 'package:mogrow/screens/home/widget/update_todo_widget.dart';
import 'package:mogrow/screens/layout/main_screen.dart';
import 'package:mogrow/screens/record/record_screen.dart';
import 'package:mogrow/screens/record/widget/record_survey.dart';
import 'package:mogrow/screens/record/widget/record_survey_detail.dart';
import 'package:mogrow/screens/record/widget/record_survey_update.dart';

class MainLocation {
  static GoRoute get route => GoRoute(
        path: '/',
        builder: (context, state) => MainScreen(key: mainScreenKey),
      );
}

class HomeLocation {
  static GoRoute get route => GoRoute(
        path: '/homeScreen',
        builder: (context, state) => HomeScreen(),
      );
}

class RecordLocation {
  static GoRoute get route => GoRoute(
        path: '/recordScreen',
        builder: (context, state) => RecordScreen(),
      );
}

class AchieveLocation {
  static GoRoute get route => GoRoute(
        path: '/achieveScreen',
        builder: (context, state) => AchieveScreen(),
      );
}

class AddTodoLocation {
  static GoRoute get route => GoRoute(
        path: '/addTodo',
        builder: (context, state) => AddTodoWidget(),
      );
}

class UpdateTodoLocation {
  static GoRoute get route => GoRoute(
        path: '/updateTodo',
        builder: (context, state) => UpdateTodoWidget(),
      );
}

class RecordSurveyLocation {
  static GoRoute get route => GoRoute(
        path: '/recordSurvey',
        builder: (context, state) => RecordSurvey(),
      );
}

class RecordSurveyDetailLocation {
  static GoRoute get route => GoRoute(
        path: '/recordSurveyDetail',
        builder: (context, state) => RecordSurveyDetail(),

        /*
        pageBuilder: (context, state) => CustomTransitionPage(
            child: RecordSurveyDetail(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              /* fade */
              // return FadeTransition(
              //   opacity: animation,
              //   child: child,
              // );

              /* down -> up */
              // return SlideTransition(
              //   position: Tween<Offset>(
              //     begin: Offset(0.0, 1.0),
              //     end: Offset.zero,
              //   ).animate(animation),
              //   child: child,
              // );

              /* 확대/축소 */
              // return ScaleTransition (scale: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 400)),

            */
      );
}

class RecordSurveyUpdateLocation {
  static GoRoute get route => GoRoute(
        path: '/recordSurveyUpdate',
        builder: (context, state) => RecordSurveyUpdate(),
      );
}

class AchieveDetailLocation {
  static GoRoute get route => GoRoute(
        path: '/achieveDetail',
        builder: (context, state) => AchieveDetail(),
      );
}

class RecordSearchLocation {
  static GoRoute get route => GoRoute(
        path: '/recordSearch',
        builder: (context, state) => RecordSearch(),
      );
}
