import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:momentum/providers/navigation/bottom_navigation_provider.dart';
import 'package:momentum/screens/bottom/bottom_screen.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
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
    );
  }
}
