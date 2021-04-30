import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = 'darkTheme';
  bool _darkTheme;
  SharedPreferences _prefs;

  bool get darkTheme => _darkTheme;

  ThemeNotifier(this._darkTheme, this._prefs); //!this.prefs

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  // _initPrefs() async {
  //   if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  //}

  _saveToPrefs() async {
//    _prefs = await SharedPreferences.getInstance();
    if (_prefs == null) _prefs = await SharedPreferences.getInstance(); //!
    _prefs.setBool(key, _darkTheme);
  }
}
