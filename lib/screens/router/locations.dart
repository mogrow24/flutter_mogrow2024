import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
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
