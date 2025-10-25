import 'package:flutter/material.dart';

import 'app_styles.dart';

class AppInputDecoration {
  static InputDecoration getDecoration({
    required String labelText,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: const OutlineInputBorder(),
      labelStyle: AppStyles.labelText,
      hintStyle: AppStyles.hintText,
      contentPadding: AppStyles.inputPadding,
      errorStyle: AppStyles.errorText,
    );
  }
}