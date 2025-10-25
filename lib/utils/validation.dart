import 'package:flutter/material.dart';

enum VALIDATION_TYPE {
  TEXT,
  DESCRIPTIVE_TEXT,
  NUMBER,
  DATE,
  EMAIL,
  PASSWORD, // Added for password validation
}

class AppLocalizations {
  static String of(BuildContext context) {
    return '';
  }
}

String? checkFieldValidation({
  required BuildContext context,
  required String? val,
  required String fieldName,
  required VALIDATION_TYPE fieldType,
  bool isRequired = true,

}) {
  // Placeholder for localization, replace with actual AppLocalizations
  final String localeName = AppLocalizations.of(context);

  // Helper function to get error message
  String getErrorMessage(String key) {
    // Replace with actual localization implementation
    final Map<String, String> errorMessages = {
      'required': '$fieldName is required',
      'descriptive_text_invalid': '$fieldName must be at least 10 characters and include letters, numbers, or special characters',
      'number_invalid': '$fieldName must be a valid number',
      'date_invalid': '$fieldName must be a valid date (MM/DD/YYYY)',
      'email_invalid': '$fieldName must be a valid email address',
      'password_invalid': '$fieldName must be at least 6 characters',
    };
    return errorMessages[key] ?? 'Invalid $fieldName';
  }

  // Regular expressions for validation
  final RegExp descriptiveTextRegex = RegExp(r'^(?=.*[a-zA-Z0-9]).{10,}$');
  final RegExp numberRegex = RegExp(r'^-?\d*\.?\d+$');
  final RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp passwordRegex = RegExp(r'^.{6,}$'); // At least 6 characters

  if (val == null || val.isEmpty) {
    if (isRequired) {
      return '$fieldName is required';
    }
    return null;
  }

  // Validate based on field type
  switch (fieldType) {
    case VALIDATION_TYPE.TEXT:
      return null; // No specific validation beyond required
    case VALIDATION_TYPE.DESCRIPTIVE_TEXT:
      return descriptiveTextRegex.hasMatch(val)
          ? null
          : getErrorMessage('descriptive_text_invalid');
    case VALIDATION_TYPE.NUMBER:
      return numberRegex.hasMatch(val)
          ? null
          : getErrorMessage('number_invalid');
    case VALIDATION_TYPE.DATE:
      return dateRegex.hasMatch(val)
          ? null
          : getErrorMessage('date_invalid');
    case VALIDATION_TYPE.EMAIL:
      return emailRegex.hasMatch(val)
          ? null
          : getErrorMessage('email_invalid');
    case VALIDATION_TYPE.PASSWORD:
      return passwordRegex.hasMatch(val)
          ? null
          : getErrorMessage('password_invalid');
  }
}