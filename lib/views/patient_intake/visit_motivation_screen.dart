import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../utils/validation.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class VisitMotivationScreen extends StatefulWidget {
  final int step;
  const VisitMotivationScreen({super.key, required this.step});

  @override
  State<VisitMotivationScreen> createState() => _VisitMotivationScreenState();
}

class _VisitMotivationScreenState extends State<VisitMotivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    _reasonController.text = formProvider.formData['visit_motivation']?['reason'] ?? '';
    _detailsController.text = formProvider.formData['visit_motivation']?['details'] ?? '';
    debugPrint('VisitMotivationScreen initialized with step: ${widget.step}');
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _next(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final formProvider = Provider.of<FormStateProvider>(context, listen: false);
      final visibilityProvider = Provider.of<ScreenVisibilityProvider>(context, listen: false);
      formProvider.updateField('visit_motivation', 'reason', _reasonController.text);
      formProvider.updateField('visit_motivation', 'details', _detailsController.text);
      debugPrint('VisitMotivationScreen: Form validated');
      final nextScreen = visibilityProvider.getNextScreen('visit_motivation');
      debugPrint('VisitMotivationScreen: Next screen is $nextScreen');
      if (nextScreen != null) {
        final step = visibilityProvider.getStepForScreen(nextScreen);
        final route = '/patient_intake/$nextScreen?step=$step';
        debugPrint('VisitMotivationScreen: Navigating to $route');
        try {
          context.go(route);
          debugPrint('VisitMotivationScreen: Navigation to $route successful');
        } catch (e, stackTrace) {
          debugPrint('VisitMotivationScreen: Navigation error: $e\n$stackTrace');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Navigation failed: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      } else {
        debugPrint('VisitMotivationScreen: No next screen, navigating to /screen_selection');
        context.go('/screen_selection');
      }
      }
  }

  void _back(BuildContext context) {
    debugPrint('VisitMotivationScreen: Navigating back to screen_selection');
    context.go('/screen_selection');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building VisitMotivationScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Motivation'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          debugPrint('Scaffold body constraints: $constraints');
          return SingleChildScrollView(
            child: Padding(
              padding: AppStyles.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      context,
                      instructionalText:
                      'What is the primary reason for your visit today? (e.g., describe any specific symptoms or conditions prompting this visit)',
                      controller: _reasonController,
                      labelText: 'Reason for Visit',
                      hintText: 'Enter the reason for visit',
                      icon: Icons.info_outline,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Reason',
                          fieldType: VALIDATION_TYPE.TEXT,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('visit_motivation', 'reason', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText:
                      'Can you provide details about the location and nature of the issue? (e.g., size, appearance, or spread of any lesions)',
                      controller: _detailsController,
                      labelText: 'Details',
                      hintText: 'Enter detailed description',
                      icon: Icons.description,
                      maxLines: 3,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Details',
                          fieldType: VALIDATION_TYPE.DESCRIPTIVE_TEXT,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('visit_motivation', 'details', value);
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomButton(
                            text: 'Back',
                            onPressed: () => _back(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: CustomButton(
                            text: 'Next',
                            onPressed: () => _next(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String labelText,
        required String hintText,
        required IconData icon,
        int? maxLines,
        String? Function(String?)? validator,
        ValueChanged<String>? onChanged,
        String? instructionalText,
      }) {
    return Padding(
      padding: AppStyles.fieldPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (instructionalText != null) ...[
            Text(
              instructionalText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppStyles.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppStyles.inputFillColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppStyles.secondaryTextColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomTextField(
                  controller: controller,
                  labelText: labelText,
                  hintText: hintText,
                  maxLines: maxLines,
                  validator: validator,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}