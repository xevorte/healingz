import 'package:flutter/material.dart';

import 'screens/loading_screen.dart';

void main() => runApp(const HealingzApp());

class HealingzApp extends StatelessWidget {
  const HealingzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healingz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF26A69A),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF26A69A)),
      ),
      home: const AppLoadingScreen(),
    );
  }
}
