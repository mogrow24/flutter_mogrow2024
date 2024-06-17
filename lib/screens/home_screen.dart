import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:momentum/providers/home_provider.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold( // 화면 구성 및 구조에 관한 것 (appBar or body)
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20
        ),
        child: Column(
          children: [
            SizedBox(
              height: 52,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('2024년 ',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Text('1월',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
              ),
              iconSize: 160,
              onPressed: () {},
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/record.svg',
              ),
              iconSize: 160,
              onPressed: () {},
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/achieve.svg',
              ),
              iconSize: 160,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
