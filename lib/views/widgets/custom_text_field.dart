import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_input_decoration.dart';
import '../../utils/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final RegExp? validationPattern;
  final String? patternErrorMessage;
  final int? maxLength;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.validationPattern,
    this.patternErrorMessage,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.fieldPadding,
      child: TextFormField(
        controller: controller,
        decoration: AppInputDecoration.getDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        maxLength: maxLength,
        enabled: enabled,
        style: AppStyles.bodyText,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
