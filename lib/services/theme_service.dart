import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  static const String _themeKey = 'isDarkMode';

  // Inicializar o tema salvo
  Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  // Alternar tema
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  // Definir tema específico
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      notifyListeners();
    }
  }

  // Tema escuro
  ThemeData get darkTheme => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    cardColor: const Color(0xFF2A2A2A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );

  // Tema claro
  ThemeData get lightTheme => ThemeData.light().copyWith(
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
      shadowColor: Colors.black12,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );

  // Obter tema atual
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Cores para o tema atual
  Color get backgroundColor => _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5);
  Color get cardColor => _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white;
  Color get textColor => _isDarkMode ? Colors.white : Colors.black;
  Color get secondaryTextColor => _isDarkMode ? Colors.grey : Colors.grey[600]!;
  Color get primaryColor => _isDarkMode ? Colors.white : Colors.blue;
  Color get accentColor => _isDarkMode ? Colors.blue : Colors.blue;
}