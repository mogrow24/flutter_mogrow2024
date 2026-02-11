import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogrow/screens/achieve/achieve_screen.dart';
import 'package:mogrow/screens/home/home_screen.dart';
import 'package:mogrow/screens/record/record_screen.dart';

final GlobalKey<_MainScreenState> mainScreenKey = GlobalKey<_MainScreenState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static void changeTab(BuildContext context, int index) {
    // 💡 context 대신 key를 통해 직접 접근
    final state = mainScreenKey.currentState;
    state?.setTab(index);
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomSelectedIndex = 0;

  void setTab(int index) {
    if (_bottomSelectedIndex != index) {
      setState(() {
        _bottomSelectedIndex = index;
      });
    }
  }

  late final _homeScreen = HomeScreen();
  late final _recordScreen = RecordScreen();
  late final _achieveScreen = AchieveScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          _homeScreen,
          _recordScreen,
          _achieveScreen,
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70, // 원하는 높이
          // color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFE2E2EA),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: () {
                    setState(() {
                      _bottomSelectedIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        width: 24,
                        height: 24,
                        _bottomSelectedIndex == 0
                            ? 'assets/icons/home/home_fill.svg'
                            : 'assets/icons/home/home.svg',
                        color: _bottomSelectedIndex == 0
                            ? Color(0xFF0066FA)
                            : Color(0xFF667086),
                      ),
                      Text(
                        '홈',
                        style: TextStyle(
                          color: _bottomSelectedIndex == 0
                              ? Color(0xFF0066FA)
                              : Color(0xFF667086),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: () {
                    setState(() {
                      _bottomSelectedIndex = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        width: 24,
                        height: 24,
                        _bottomSelectedIndex == 1
                            ? 'assets/icons/record/record_fill.svg'
                            : 'assets/icons/record/record.svg',
                        color: _bottomSelectedIndex == 1
                            ? Color(0xFF0066FA)
                            : Color(0xFF667086),
                      ),
                      Text(
                        '기록',
                        style: TextStyle(
                          color: _bottomSelectedIndex == 1
                              ? Color(0xFF0066FA)
                              : Color(0xFF667086),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: () {
                    setState(() {
                      _bottomSelectedIndex = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        width: 24,
                        height: 24,
                        _bottomSelectedIndex == 2
                            ? 'assets/icons/achieve/achieve.svg'
                            : 'assets/icons/achieve/achieve.svg',
                        color: _bottomSelectedIndex == 2
                            ? Color(0xFF0066FA)
                            : Color(0xFF667086),
                      ),
                      Text(
                        '달성',
                        style: TextStyle(
                          color: _bottomSelectedIndex == 2
                              ? Color(0xFF0066FA)
                              : Color(0xFF667086),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.white,
      //   selectedLabelStyle: TextStyle(
      //     fontSize: 12,
      //     fontWeight: FontWeight.bold,
      //     color: Color(0xFF0066FA),
      //   ),
      //   unselectedLabelStyle: TextStyle(
      //     fontSize: 12,
      //     fontWeight: FontWeight.bold,
      //     color: Color(0xFF667086),
      //   ),
      //   selectedItemColor: Color(0xFF0066FA),
      //   unselectedItemColor: Color(0xFF667086),
      //   elevation: 4,
      //   currentIndex: _bottomSelectedIndex,
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: ImageIcon(
      //         AssetImage(
      //           _bottomSelectedIndex == 0
      //               ? 'assets/icons/home/fill.png'
      //               : 'assets/icons/home/line.png',
      //         ),
      //       ),
      //       label: '홈',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: ImageIcon(
      //         AssetImage(
      //           _bottomSelectedIndex == 1
      //               ? 'assets/icons/record/fill.png'
      //               : 'assets/icons/record/line.png',
      //         ),
      //       ),
      //       label: '기록',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: ImageIcon(
      //         AssetImage(
      //           _bottomSelectedIndex == 2
      //               ? 'assets/icons/achieve/fill.png'
      //               : 'assets/icons/achieve/line.png',
      //         ),
      //       ),
      //       label: '달성',
      //     ),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       _bottomSelectedIndex = index;
      //     });
      //   },
      // ),
      // floatingActionButton
      // floatingActionButton: MaterialButton(
      //   onPressed: () => context.beamToNamed('addTodo'),
      //   shape: CircleBorder(),
      //   height: 48,
      //   color: Color(0xFF0066FA),
      //   child: Icon(
      //     Icons.add,
      //     color: Color(0xFFFFFFFF),
      //     size: 28,
      //   ),
      // ),
    );
  }
}
