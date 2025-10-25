import 'package:flutter/material.dart';

class FormStateProvider extends ChangeNotifier {
  // Only the sections used in the new flow
  final Map<String, Map<String, dynamic>> _formData = {
    'visit_motivation': {},
    'patient_information': {},
    'skin_sun': {},
    'family_history': {},
    'patient_medical_history': {},
    'surgeries': {}, // 1. Add the new 'surgeries' section
    'symptoms': {},
    'review_submit': {}, // optional
    'register': {}, // Add register section
    'login': {}, // Add login section
  };

  final Map<String, Map<String, String?>> _errors = {
    'visit_motivation': {},
    'patient_information': {},
    'skin_sun': {},
    'patient_medical_history': {},
    'family_history': {},
    'symptoms': {},
    'surgeries': {}, // 2. Add the 'surgeries' section for errors

  };

  // Getters
  Map<String, Map<String, dynamic>> get formData => Map.unmodifiable(_formData);
  Map<String, Map<String, String?>> get errors => Map.unmodifiable(_errors);

  // Update field
  void updateField(String section, String field, dynamic value, {bool silent = false}) { // 3. Add the 'silent' parameter
    _formData.putIfAbsent(section, () => {});
    _formData[section]![field] = value;
    _clearError(section, field);

    // 4. Only notify listeners if the update is not silent
    if (!silent) {
      notifyListeners();
    }
  }

  // Validation - RENAMED THE METHOD
  void setValidationError(String section, String field, String error) {
    _errors.putIfAbsent(section, () => {});
    _errors[section]![field] = error;
    notifyListeners();
  }

  void _clearError(String section, String field) {
    if (_errors.containsKey(section)) {
      _errors[section]![field] = null;
    }
  }

  bool validateSection(String section) {
    final sectionErrors = _errors[section];
    return sectionErrors == null || sectionErrors.values.every((e) => e == null);
  }

  bool validateForm() {
    return _errors.keys.every(validateSection);
  }

  void clearForm() {
    _formData.forEach((k, _) => _formData[k] = {});
    _errors.forEach((k, _) => _errors[k] = {});
    notifyListeners();
  }
}
