import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../utils/validation.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_checkbox_list_tile.dart';
import '../widgets/custom_text_field.dart';

import 'package:go_router/go_router.dart';

class AdmissionScreen extends StatefulWidget {
  final int step;
  const AdmissionScreen({super.key, required this.step});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _durationController = TextEditingController();
  final _facilityController = TextEditingController();
  bool _isAdmitted = false;

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    _isAdmitted = formProvider.formData['admission']?['is_admitted'] == 'true';
    _reasonController.text = formProvider.formData['admission']?['reason'] ?? '';
    _durationController.text = formProvider.formData['admission']?['duration'] ?? '';
    _facilityController.text = formProvider.formData['admission']?['facility'] ?? '';
    debugPrint('AdmissionScreen initialized with step: ${widget.step}');
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _durationController.dispose();
    _facilityController.dispose();
    super.dispose();
  }

  void _next(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final formProvider = Provider.of<FormStateProvider>(context, listen: false);
      final visibilityProvider = Provider.of<ScreenVisibilityProvider>(context, listen: false);
      formProvider.updateField('admission', 'is_admitted', _isAdmitted.toString());
      formProvider.updateField('admission', 'reason', _reasonController.text);
      formProvider.updateField('admission', 'duration', _durationController.text);
      formProvider.updateField('admission', 'facility', _facilityController.text);
      debugPrint('AdmissionScreen: Form validated');
      final nextScreen = visibilityProvider.getNextScreen('admission');
      if (nextScreen != null) {
        final step = visibilityProvider.getStepForScreen(nextScreen);
        context.go('/patient_intake/$nextScreen?step=$step');
      } else {
        context.go('/screen_selection');
      }
    } else {
      debugPrint('AdmissionScreen: Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please correct the errors in the form'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _back(BuildContext context) {
    final visibilityProvider = Provider.of<ScreenVisibilityProvider>(context, listen: false);
    debugPrint('AdmissionScreen: Navigating back');
    final prevScreen = visibilityProvider.getPreviousScreen('admission');
    if (prevScreen != null) {
      final step = visibilityProvider.getStepForScreen(prevScreen);
      context.go('/patient_intake/$prevScreen?step=$step');
    } else {
      context.go('/screen_selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building AdmissionScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admission'),
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
                    Text(
                      'Have you been admitted to a hospital or clinic for this condition?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: AppStyles.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: _isAdmitted,
                      onChanged: (value) {
                        setState(() {
                          _isAdmitted = value;
                        });
                      },
                      title: Text(_isAdmitted ? 'Yes' : 'No'),
                      activeColor: AppStyles.accentColor,
                    ),
                    if (_isAdmitted) ...[
                      const SizedBox(height: 20),
                      _buildTextField(
                        context,
                        instructionalText: 'If yes, what was the reason for admission?',
                        controller: _reasonController,
                        labelText: 'Reason for Admission',
                        hintText: 'Enter the reason for admission',
                        icon: Icons.info_outline,
                        validator: (value) {
                          return checkFieldValidation(
                            context: context,
                            val: value,
                            fieldName: 'Reason for Admission',
                            fieldType: VALIDATION_TYPE.TEXT,
                            isRequired: _isAdmitted,
                          );
                        },
                        onChanged: (value) {
                          Provider.of<FormStateProvider>(context, listen: false)
                              .updateField('admission', 'reason', value);
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText: 'When was the admission, and how long did it last?',
                      controller: _durationController,
                      labelText: 'Admission Duration',
                      hintText: 'Enter dates and duration',
                      icon: Icons.calendar_today,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Admission Duration',
                          fieldType: VALIDATION_TYPE.TEXT,
                          isRequired: _isAdmitted,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('admission', 'duration', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText:
                      'Which care center or facility provided treatment for this condition? (e.g., outpatient clinic, hospital)',
                      controller: _facilityController,
                      labelText: 'Care Facility',
                      hintText: 'Enter facility name',
                      icon: Icons.local_hospital,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Care Facility',
                          fieldType: VALIDATION_TYPE.TEXT,
                          isRequired: _isAdmitted,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('admission', 'facility', value);
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