import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:momentum/providers/home_provider.dart';
import 'package:momentum/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}