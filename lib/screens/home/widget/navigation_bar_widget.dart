import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/image/image_model.dart';
import '../../../providers/navigation/bottom_navigation_provider.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  Widget _bottomNavigationBar(BottomNavigationProvider bottomNavigationProvider) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffECECF0), width: 1)), // 라인효과
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        // selectedIconTheme: IconThemeData(size: 24),
        // unselectedIconTheme: IconThemeData(size: 24),
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
        items: [
          BottomNavigationBarItem(
            icon: ImageData(
              path: 'assets/icons/home/line.png',
            ),
            activeIcon: ImageData(
              path: 'assets/icons/home/fill.png',
              color: Colors.deepPurpleAccent,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: ImageData(
              path: 'assets/icons/record/line.png',
            ),
            activeIcon: ImageData(
              path: 'assets/icons/record/fill.png',
              color: Colors.deepPurpleAccent,
            ),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: ImageData(
              path: 'assets/icons/achieve/line.png',
            ),
            activeIcon: ImageData(
              path: 'assets/icons/achieve/fill.png',
              color: Colors.deepPurpleAccent,
            ),
            label: '달성',
          ),
        ],
        // 현재 페이지 : _bottomNavigationProvider의 currentPage
        currentIndex: bottomNavigationProvider.currentPage,

        // _bottomNavigationProvider에 updateCurrentPage를 통해 index를 전달
        onTap: (index) {
          bottomNavigationProvider.updateCurrentPage(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // Provider를 호출해 접근
    final bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);

    return _bottomNavigationBar(bottomNavigationProvider);
  }
}
