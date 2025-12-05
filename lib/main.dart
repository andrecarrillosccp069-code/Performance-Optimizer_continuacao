import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PerformanceOptimizerApp());
}

class PerformanceOptimizerApp extends StatelessWidget {
  const PerformanceOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Optimizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardColor: const Color(0xFF2A2A2A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}