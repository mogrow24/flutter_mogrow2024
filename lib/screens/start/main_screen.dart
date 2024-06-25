import 'package:flutter/material.dart';
import 'package:momentum/screens/achieve/achieve_screen.dart';
import 'package:momentum/screens/home/home_screen.dart';
import 'package:momentum/screens/record/record_screen.dart';

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
          color: Colors.deepPurpleAccent,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black38,
        ),
        elevation: 10,
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
    );
  }
}
