import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class IntakeSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final Widget? child; // Shown when value == true

  const IntakeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          value: value,
          onChanged: onChanged,
          title: Text(title),
          activeColor: AppStyles.accentColor,
        ),
        if (value && child != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 56), // Align with switch
            child: child!,
          ),
        ],
      ],
    );
  }
}