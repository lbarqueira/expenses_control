import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingNotifier extends ChangeNotifier {
  final String key = 'seen';
  SharedPreferences _prefs;
  bool _isFirstSeen;

  bool get isFirstSeen => _isFirstSeen;

  OnboardingNotifier(this._isFirstSeen, this._prefs);
  // _isFirstSeen = null; //!
  // _loadFromPrefs();

  changeOnboarding() {
    _isFirstSeen = false;
    _saveToPrefs();
    notifyListeners();
  }

  _saveToPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(key, false); //! onboarding seen only one time
  }
}
