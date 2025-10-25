import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_styles.dart';
import 'intake_button_row.dart';

class IntakeForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final String? nextButtonText; // 1. Add the new parameter here

  const IntakeForm({
    super.key,
    required this.formKey,
    required this.children,
    this.onBack,
    required this.onNext,
    this.nextButtonText, // 2. Add it to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle(context)), centerTitle: true),
      body: SingleChildScrollView(
        padding: AppStyles.screenPadding,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...children,
              const SizedBox(height: 30),
              IntakeButtonRow(
                onBack: onBack ?? () => context.pop(),
                onNext: () {
                  if (formKey.currentState!.validate()) {
                    onNext();
                  }
                },
                nextButtonText: nextButtonText, // 3. Pass the text down to the button row
                showBack: onBack != null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    // This logic might be brittle with GoRouter, let's make it more robust.
    // GoRouter provides the route path directly.
    final route = GoRouter.of(context).routeInformationProvider.value.uri.path;
    final path = route.split('/').lastWhere((e) => e.isNotEmpty, orElse: () => '');
    // Capitalize the first letter and replace underscores for a clean title.
    final title = path.replaceAll('_', ' ');
    return title.isNotEmpty ? '${title[0].toUpperCase()}${title.substring(1)}' : 'Intake Form';
  }
}
