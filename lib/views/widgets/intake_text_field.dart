import 'package:flutter/material.dart';

class IntakeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;
  final int? maxLines;
  final String? instructionalText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // 1. Add the parameter here

  const IntakeTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.maxLines = 1,
    this.instructionalText,
    this.validator,
    this.keyboardType, // 2. Add to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (instructionalText != null) ...[
          Text(instructionalText!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType, // 3. Use the parameter here
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
