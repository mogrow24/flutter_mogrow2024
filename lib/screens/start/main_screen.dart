import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mogrow/screens/achieve/achieve_screen.dart';
import 'package:mogrow/screens/home/home_screen.dart';
import 'package:mogrow/screens/record/record_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          HomeScreen(),
          RecordScreen(),
          AchieveScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0066FA),
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF667086),
        ),
        selectedItemColor: Color(0xFF0066FA),
        unselectedItemColor: Color(0xFF667086),
        elevation: 4,
        currentIndex: _bottomSelectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _bottomSelectedIndex == 0
                    ? 'assets/icons/home/fill.png'
                    : 'assets/icons/home/line.png',
              ),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _bottomSelectedIndex == 1
                    ? 'assets/icons/record/fill.png'
                    : 'assets/icons/record/line.png',
              ),
            ),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _bottomSelectedIndex == 2
                    ? 'assets/icons/achieve/fill.png'
                    : 'assets/icons/achieve/line.png',
              ),
            ),
            label: '달성',
          ),
        ],
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
          });
        },
      ),
      // floatingActionButton
      floatingActionButton: MaterialButton(
        onPressed: () => context.beamToNamed('addTodo'),
        shape: CircleBorder(),
        height: 48,
        color: Color(0xFF0066FA),
        child: Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 28,
        ),
      ),
    );
  }
}
