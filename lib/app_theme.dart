import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF27AAA5);
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Color(0xFF171044),
        fontWeight: FontWeight.w800,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF171044),
        fontWeight: FontWeight.w800,
      ),
      bodyLarge: TextStyle(color: Color(0xFFAAA7B5)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
