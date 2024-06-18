import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/navigation/bottom_navigation_provider.dart';
import '../../achieve/achieve_screen.dart';
import '../../record/record_screen.dart';
import '../home_screen.dart';

class NavigationBodyWidget extends StatelessWidget {
  const NavigationBodyWidget({super.key});

  // 네비게이션바 UI Widget
  Widget _navigationBody(BottomNavigationProvider bottomNavigationProvider) {
    // switch를 통해 currentPage에 따라 네비게이션을 구동시킨다.
    switch (bottomNavigationProvider.currentPage) {
      case 0:
        return HomeScreen();

      case 1:
        return RecordScreen();

      case 2:
        return AchieveScreen();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {

    // Provider를 호출해 접근
    final bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);

    return _navigationBody(bottomNavigationProvider);
  }
}
