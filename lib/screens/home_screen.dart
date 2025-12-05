import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/subscription_service.dart';
import '../services/device_service.dart';
import 'analysis_screen.dart';
import 'settings_screen.dart';
import 'storage_screen.dart';
import 'performance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AnalysisScreen(),
    const AnalysisScreen(),
    const StorageScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final subscriptionService = Provider.of<SubscriptionService>(context);
    
    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: themeService.borderColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: themeService.backgroundColor,
          selectedItemColor: themeService.textColor,
          unselectedItemColor: themeService.secondaryTextColor,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          iconSize: 24,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.home_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.home),
              ),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.analytics_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.analytics),
              ),
              label: 'Análise',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.storage_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.storage),
              ),
              label: 'Armazenamento',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.settings_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Icon(Icons.settings),
              ),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}