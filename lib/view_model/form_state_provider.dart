import 'package:flutter/material.dart';

class FormStateProvider extends ChangeNotifier {
  // Store form data as a nested map: {section: {field: value}}
  final Map<String, Map<String, dynamic>> _formData = {
    'visit_motivation': {},
    'admission': {},
    'patient_information': {},
    'patient_medical_history': {},
    'surgeries': {},
    'symptoms': {},
    'medical_examinations': {},
    'diagnosis_tests': {},
    'treatments': {},
    'discharge': {},
  };

  // Store validation errors as a nested map: {section: {field: errorMessage}}
  final Map<String, Map<String, String?>> _validationErrors = {
    'visit_motivation': {},
    'admission': {},
    'patient_information': {},
    'patient_medical_history': {},
    'surgeries': {},
    'symptoms': {},
    'medical_examinations': {},
    'diagnosis_tests': {},
    'treatments': {},
    'discharge': {},
  };

  // Getter for form data
  Map<String, Map<String, dynamic>> get formData => _formData;

  // Getter for validation errors
  Map<String, Map<String, String?>> get validationErrors => _validationErrors;

  // Update a field value in the specified section
  void updateField(String section, String field, dynamic value) {
    if (!_formData.containsKey(section)) {
      _formData[section] = {};
    }
    _formData[section]![field] = value;
    notifyListeners();
  }

  // Set or clear a validation error for a field
  void setValidationError(String section, String field, String? error) {
    if (!_validationErrors.containsKey(section)) {
      _validationErrors[section] = {};
    }
    _validationErrors[section]![field] = error;
    notifyListeners();
  }

  // Validate a specific section (returns true if no errors)
  bool validateSection(String section) {
    if (!_validationErrors.containsKey(section)) {
      return true; // No fields, no errors
    }
    return _validationErrors[section]!.values.every((error) => error == null);
  }

  // Validate the entire form (returns true if all sections are valid)
  bool validateForm() {
    return _validationErrors.keys.every((section) => validateSection(section));
  }

  // Submit the form (placeholder for actual submission logic)
  void submitForm() {
    if (validateForm()) {
      // Placeholder: Print form data to console
      print('Form submitted successfully:');
      _formData.forEach((section, fields) {
        print('$section: $fields');
      });
      // TODO: Implement actual submission logic (e.g., API call, local storage)
    } else {
      print('Form submission failed due to validation errors:');
      _validationErrors.forEach((section, errors) {
        print('$section errors: $errors');
      });
    }
    notifyListeners();
  }

  // Clear all form data and errors
  void clearForm() {
    _formData.forEach((section, _) {
      _formData[section] = {};
      _validationErrors[section] = {};
    });
    notifyListeners();
  }
}