import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ExtendedImage.asset(
              'assets/images/momentum.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ), // 이미지 캐시 관련 라이브러리
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              color: Color(0xFF3C3C3C),
            ),
          ],
        ),
      ),
    );
  }
}
