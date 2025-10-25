import 'package:flutter/cupertino.dart';

class ScreenVisibilityProvider with ChangeNotifier {
  // Only the screens used in the new flow
  final Map<String, bool> _screenVisibility = {
    'visit_motivation': true,
    'patient_information': true,
    'skin_type_sun': true,

    'patient_medical_history': true,
    'family_history': true,
    'symptoms': true,
    'surgeries': true,

    'review_submit': true,
  };


  Map<String, bool> get screenVisibility => Map.unmodifiable(_screenVisibility);

  void toggleScreen(String screen, bool isEnabled) {
    if (_screenVisibility.containsKey(screen)) {
      _screenVisibility[screen] = isEnabled;
      notifyListeners();
      debugPrint('ScreenVisibilityProvider: $screen → $isEnabled');
    }
  }

  List<String> getEnabledScreens() {
    return _screenVisibility.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  int getStepForScreen(String screen) {
    final enabled = getEnabledScreens();
    final index = enabled.indexOf(screen);
    return index >= 0 ? index : 0;
  }

  String? getNextScreen(String currentScreen) {
    final enabled = getEnabledScreens();
    final currentIndex = enabled.indexOf(currentScreen);
    if (currentIndex >= 0 && currentIndex < enabled.length - 1) {
      return enabled[currentIndex + 1];
    }
    return null;
  }

  String? getPreviousScreen(String currentScreen) {
    final enabled = getEnabledScreens();
    final currentIndex = enabled.indexOf(currentScreen);
    if (currentIndex > 0) {
      return enabled[currentIndex - 1];
    }
    return null;
  }

  /// Optional: Reset to default (useful for testing)
  void reset() {
    // Cannot reassign a final variable. Clear and update instead.
    _screenVisibility.clear();
    _screenVisibility.addAll({
      'visit_motivation': true,
      'patient_information': true,
      'skin_type_sun': true,
      'family_history': true,
      'patient_medical_history': true,
      'symptoms': true,
      'surgeries': true,
      'review_submit': true,
    });
    notifyListeners();
  }
}
