import 'package:mogrow/database/database.dart';
import 'package:mogrow/providers/achieve_list.dart';
import 'package:mogrow/providers/goal_list.dart';
import 'package:mogrow/providers/multi_image_picker.dart';
import 'package:mogrow/providers/photo_manager.dart';
import 'package:mogrow/providers/record_list.dart';
import 'package:mogrow/providers/todo_list.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderList {
  static final List<SingleChildWidget> providers = [
    Provider<Database>(
      create: (_) => Database(), // 데이터베이스 인스턴스 생성
      dispose: (_, Database db) => db.close(), // 앱 종료 시 데이터베이스 닫기
    ),
    ChangeNotifierProvider(
        create: (context) =>
            TodoListProvider(Provider.of<Database>(context, listen: false))),
    ChangeNotifierProvider(
        lazy: false,
        create: (context) =>
            GoalListProvider(Provider.of<Database>(context, listen: false))),
    ChangeNotifierProvider(
        create: (context) =>
            RecordListProvider(Provider.of<Database>(context, listen: false))),
    ChangeNotifierProvider(
        create: (context) =>
            AchieveListProvider(Provider.of<Database>(context, listen: false))),
    ChangeNotifierProvider(
        create: (context) =>
            MultiImagePicker(Provider.of<Database>(context, listen: false))),
    ChangeNotifierProvider(
        create: (context) => PhotoManagerProvider(
            Provider.of<Database>(context, listen: false))),
  ];
}
