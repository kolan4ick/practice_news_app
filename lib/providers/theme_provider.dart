import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _isDarkMode = false;
    _loadFromPrefs();
    notifyListeners();
  }

  void toggleTheme(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    _isDarkMode = value;
    notifyListeners();
    _saveToPrefs();
  }

  _loadFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _isDarkMode = preferences.getBool('theme') ?? false;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('theme', _isDarkMode);
  }
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
    ),
    primaryColorDark: Colors.grey[600],
    primaryColorLight: const Color.fromARGB(255, 143, 218, 212),
    primaryColor: Color.fromARGB(255, 95, 202, 193),
    colorScheme: const ColorScheme.light(secondary: Color(0xFF5FCAC1)),
    bottomAppBarColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFE0F2F1),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
    ),
    primaryColorDark: Colors.grey[600],
    primaryColorLight: Colors.grey[400],
    primaryColor: Colors.grey[700],
    colorScheme: ColorScheme.dark(secondary: Colors.grey[700] ?? Colors.grey),
    bottomAppBarColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.grey[900],
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
