import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:momentum/screens/home/addTodo/add_todo.dart';
import 'package:momentum/screens/start/main_screen.dart';

class MainLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: MainScreen(),
        key: ValueKey('home'),
      ),
    ];
  }

  @override
  List get pathBlueprints => ['/'];
}

class AddTodoLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      ...MainLocation().buildPages(context, state),
      if (state.pathBlueprintSegments
          .contains('addTodo')) // '/' 은 최초 페이지라 설정 안해도 된다.
        BeamPage(
          child: AddTodo(),
          key: ValueKey('addTodo'),
        ),
    ];
  }

  @override
  List get pathBlueprints => ['/addTodo'];
}
