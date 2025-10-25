import 'package:flutter/material.dart';

class IntakeCheckboxGroup extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final String title;

  const IntakeCheckboxGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...options.map((opt) => CheckboxListTile(
          title: Text(opt),
          value: selected.contains(opt),
          onChanged: (v) {
            final newList = List<String>.from(selected);
            if (v == true) {
              newList.add(opt);
            } else {
              newList.remove(opt);
            }
            onChanged(newList);
          },
        )),
      ],
    );
  }
}