import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingNotifier extends ChangeNotifier {
  final String key = "seen";
  SharedPreferences _prefs;
  bool _isFirstSeen;

  bool get isFirstSeen => _isFirstSeen;

  OnboardingNotifier() {
    _isFirstSeen = null; //!
    _loadFromPrefs();
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  changeOnboarding() {
    _isFirstSeen = false;
    _saveToPrefs();
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, true);
  }

  _loadFromPrefs() async {
    await _initPrefs();
    if (_prefs.containsKey(key)) {
      _isFirstSeen = false;
      notifyListeners();
    } else {
      await _prefs.setBool(key, false);
      _isFirstSeen = true; //!
      notifyListeners(); //!
    }
  }
}
