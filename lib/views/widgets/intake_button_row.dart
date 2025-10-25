import 'package:flutter/material.dart';

class IntakeButtonRow extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool showBack;
  final String? nextButtonText; // 1. Add the new parameter here

  const IntakeButtonRow({
    super.key,
    required this.onBack,
    required this.onNext,
    this.showBack = true,
    this.nextButtonText, // 2. Add it to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBack)
          TextButton(
            onPressed: onBack,
            child: const Text('Back'),
          ),
        const Spacer(),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          // 3. Use the new parameter, with "Next" as a default fallback.
          child: Text(nextButtonText ?? 'Next'),
        ),
      ],
    );
  }
}
