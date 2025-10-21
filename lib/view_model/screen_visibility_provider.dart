import 'package:flutter/foundation.dart';

class ScreenVisibilityProvider with ChangeNotifier {
  Map<String, bool> _screenVisibility = {
    'visit_motivation': true,
    'admission': true,
    'patient_information': true,
    // 'patient_medical_history': true,
    // 'surgeries': true,
    // 'symptoms': true,
    // 'medical_examinations': true,
    // 'diagnosis_tests': true,
    // 'treatments': true,
    // 'discharge': true,
  };

  Map<String, bool> get screenVisibility => _screenVisibility;

  void toggleScreen(String screen, bool isEnabled) {
    _screenVisibility[screen] = isEnabled;
    notifyListeners();
    debugPrint('ScreenVisibilityProvider: Updated $screen to $isEnabled');
  }

  List<String> getEnabledScreens() {
    return _screenVisibility.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  int getStepForScreen(String screen) {
    final enabledScreens = getEnabledScreens();
    final index = enabledScreens.indexOf(screen);
    return index >= 0 ? index : 0;
  }

  String? getNextScreen(String currentScreen) {
    final enabledScreens = getEnabledScreens();
    final currentIndex = enabledScreens.indexOf(currentScreen);
    if (currentIndex >= 0 && currentIndex < enabledScreens.length - 1) {
      return enabledScreens[currentIndex + 1];
    }
    return null;
  }

  String? getPreviousScreen(String currentScreen) {
    final enabledScreens = getEnabledScreens();
    final currentIndex = enabledScreens.indexOf(currentScreen);
    if (currentIndex > 0) {
      return enabledScreens[currentIndex - 1];
    }
    return null;
  }
}