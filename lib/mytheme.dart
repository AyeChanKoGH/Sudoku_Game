//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  canvasColor: const Color(0xFF7d8379),
  backgroundColor: Colors.transparent,
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.green),
  dividerColor: Colors.white54,
);

class ThemeNotifier with ChangeNotifier {
  bool _isdark = false;
  get getTheme => _isdark ? darkTheme : lightTheme;
  get isDark => _isdark;
  setTheme(bool isdark) {
    _isdark = isdark;
    notifyListeners();
  }

  setAlt() {
    _isdark = !_isdark;
    notifyListeners();
  }
}
