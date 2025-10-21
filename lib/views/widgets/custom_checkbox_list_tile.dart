import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';
import 'custom_text_field.dart';

class CustomCheckboxListTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? conditionalLabel;
  final String? conditionalHint;
  final TextEditingController? conditionalController;
  final String? Function(String?)? conditionalValidator;
  final ValueChanged<String>? conditionalOnChanged;

  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.conditionalLabel,
    this.conditionalHint,
    this.conditionalController,
    this.conditionalValidator,
    this.conditionalOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(title, style: AppStyles.bodyText),
          value: value,
          onChanged: onChanged,
          activeColor: AppStyles.primaryColor,
        ),
        if (value && conditionalLabel != null)
          CustomTextField(
            controller: conditionalController,
            labelText: conditionalLabel!,
            hintText: conditionalHint,
            maxLines: 3,
            validator: conditionalValidator,
            onChanged: conditionalOnChanged,
          ),
      ],
    );
  }
}
