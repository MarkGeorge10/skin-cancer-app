import 'package:flutter/material.dart';

/// Colors
const Color primaryColor = Color(0xFF28895E);
const Color primaryLightColor = Color(0xFFDFF6E5);
const Color accentColor = Color(0xFF56CCF2);
const Color backgroundColor = Color(0xFFF9F9F9);
const Color textColor = Colors.black87;
const Color textSecondaryColor = Colors.black54;
const Color inputFillColor = Color(0xFFF2F2F2);

/// Text Styles
const TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: textColor,
);

const TextStyle subheadingStyle = TextStyle(
  fontSize: 16,
  color: textSecondaryColor,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

/// Input decoration
InputDecoration inputDecoration({required String hintText, IconData? icon}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
    filled: true,
    fillColor: inputFillColor,
    prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );
}
