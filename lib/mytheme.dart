//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  canvasColor: const Color(0xFF515556),
  backgroundColor: Colors.grey[700],
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.white54,
  //hashColor: Colors.grey[500],
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 28.0),
    headline3: TextStyle(fontSize: 20, fontFamily: 'Pyidaungsu'),
    headline5: TextStyle(fontSize: 14.0),
    headline6: TextStyle(fontSize: 11.0),
    bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Pyidaungsu'),
  ),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  backgroundColor: Colors.grey[300],
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.green),
  dividerColor: Colors.black12,
  //hashColor: Colors.grey[200],
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 28),
    headline3: TextStyle(fontSize: 20, fontFamily: 'Pyidaungsu'),
    headline5: TextStyle(fontSize: 14.0),
    headline6: TextStyle(fontSize: 11.0),
    bodyText2: TextStyle(fontSize: 16.0, fontFamily: 'Pyidaungsu'),
  ),
);

class ThemeNotifier with ChangeNotifier {
  bool _isdark = false;
  get getTheme => _isdark ? darkTheme : lightTheme;
  get isDark => _isdark;
  bool isdark() {
    return _isdark;
  }

  final String key = "theme";
  SharedPreferences? _pref;
  ThemeNotifier() {
    _loadFromPrefs();
  }
  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isdark = _pref?.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref?.setBool(key, _isdark);
  }

  setTheme(bool isdark) {
    _isdark = isdark;
    _saveToPrefs();
    notifyListeners();
  }

  setAlt() {
    _isdark = !_isdark;
    _saveToPrefs();
    notifyListeners();
  }
}
