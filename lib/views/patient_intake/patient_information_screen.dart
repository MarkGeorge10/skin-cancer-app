import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../utils/validation.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_checkbox_list_tile.dart';
import '../widgets/custom_text_field.dart';
import '../../view_model/form_state_provider.dart';
import 'package:go_router/go_router.dart';

class PatientInformationScreen extends StatefulWidget {
  final int step;
  const PatientInformationScreen({super.key, required this.step});

  @override
  State<PatientInformationScreen> createState() => _PatientInformationScreenState();
}

class _PatientInformationScreenState extends State<PatientInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _ethnicityController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _hasFamilyHistory = false;
  final _familyHistoryController = TextEditingController();
  bool _hasTraveled = false;
  final _travelDetailsController = TextEditingController();
  final _socioeconomicController = TextEditingController();
  final _occupationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    _ageController.text = formProvider.formData['patient_information']?['age'] ?? '';
    _sexController.text = formProvider.formData['patient_information']?['sex'] ?? '';
    _ethnicityController.text = formProvider.formData['patient_information']?['ethnicity'] ?? '';
    _weightController.text = formProvider.formData['patient_information']?['weight'] ?? '';
    _heightController.text = formProvider.formData['patient_information']?['height'] ?? '';
    _hasFamilyHistory = formProvider.formData['patient_information']?['has_family_history'] == 'true';
    _familyHistoryController.text = formProvider.formData['patient_information']?['family_history'] ?? '';
    _hasTraveled = formProvider.formData['patient_information']?['has_traveled'] == 'true';
    _travelDetailsController.text = formProvider.formData['patient_information']?['travel_details'] ?? '';
    _socioeconomicController.text = formProvider.formData['patient_information']?['socioeconomic'] ?? '';
    _occupationController.text = formProvider.formData['patient_information']?['occupation'] ?? '';
    debugPrint('PatientInformationScreen initialized with step: ${widget.step}');
  }

  @override
  void dispose() {
    _ageController.dispose();
    _sexController.dispose();
    _ethnicityController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _familyHistoryController.dispose();
    _travelDetailsController.dispose();
    _socioeconomicController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  void _next(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final formProvider = Provider.of<FormStateProvider>(context, listen: false);
      final visibilityProvider = Provider.of<ScreenVisibilityProvider>(context, listen: false);
      formProvider.updateField('patient_information', 'age', _ageController.text);
      formProvider.updateField('patient_information', 'sex', _sexController.text);
      formProvider.updateField('patient_information', 'ethnicity', _ethnicityController.text);
      formProvider.updateField('patient_information', 'weight', _weightController.text);
      formProvider.updateField('patient_information', 'height', _heightController.text);
      formProvider.updateField('patient_information', 'has_family_history', _hasFamilyHistory.toString());
      formProvider.updateField('patient_information', 'family_history', _familyHistoryController.text);
      formProvider.updateField('patient_information', 'has_traveled', _hasTraveled.toString());
      formProvider.updateField('patient_information', 'travel_details', _travelDetailsController.text);
      formProvider.updateField('patient_information', 'socioeconomic', _socioeconomicController.text);
      formProvider.updateField('patient_information', 'occupation', _occupationController.text);
      debugPrint('PatientInformationScreen: Form validated');
      final nextScreen = visibilityProvider.getNextScreen('patient_information');
      if (nextScreen != null) {
        final step = visibilityProvider.getStepForScreen(nextScreen);
        context.go('/patient_intake/$nextScreen?step=$step');
      } else {
        context.go('/screen_selection');
      }
    } else {
      debugPrint('PatientInformationScreen: Form validation failed');
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
    debugPrint('PatientInformationScreen: Navigating back');
    final prevScreen = visibilityProvider.getPreviousScreen('patient_information');
    if (prevScreen != null) {
      final step = visibilityProvider.getStepForScreen(prevScreen);
      context.go('/patient_intake/$prevScreen?step=$step');
    } else {
      context.go('/screen_selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building PatientInformationScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Information'),
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
                      instructionalText: 'What is your age?',
                      controller: _ageController,
                      labelText: 'Age',
                      hintText: 'Enter your age',
                      icon: Icons.cake,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Age',
                          fieldType: VALIDATION_TYPE.NUMBER,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('patient_information', 'age', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText: 'What is your sex?',
                      controller: _sexController,
                      labelText: 'Sex',
                      hintText: 'Enter your sex',
                      icon: Icons.person,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Sex',
                          fieldType: VALIDATION_TYPE.TEXT,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('patient_information', 'sex', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText: 'What is your ethnicity?',
                      controller: _ethnicityController,
                      labelText: 'Ethnicity',
                      hintText: 'Enter your ethnicity',
                      icon: Icons.group,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Ethnicity',
                          fieldType: VALIDATION_TYPE.TEXT,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('patient_information', 'ethnicity', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText: 'What is your current weight?',
                      controller: _weightController,
                      labelText: 'Weight',
                      hintText: 'Enter your weight',
                      icon: Icons.fitness_center,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Weight',
                          fieldType: VALIDATION_TYPE.NUMBER,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('patient_information', 'weight', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText: 'What is your height?',
                      controller: _heightController,
                      labelText: 'Height',
                      hintText: 'Enter your height',
                      icon: Icons.height,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Height',
                          fieldType: VALIDATION_TYPE.NUMBER,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('patient_information', 'height', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Do you have any family medical history?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: AppStyles.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: _hasFamilyHistory,
                      onChanged: (value) {
                        setState(() {
                          _hasFamilyHistory = value;
                        });
                      },
                      title: Text(_hasFamilyHistory ? 'Yes' : 'No'),
                      activeColor: AppStyles.accentColor,
                    ),
                    if (_hasFamilyHistory) ...[
                      const SizedBox(height: 20),
                      _buildTextField(
                        context,
                        instructionalText: 'If yes, please provide details about conditions in your immediate family.',
                        controller: _familyHistoryController,
                        labelText: 'Family Medical History',
                        hintText: 'Enter family medical history',
                        icon: Icons.family_restroom,
                        validator: (value) {
                          return checkFieldValidation(
                            context: context,
                            val: value,
                            fieldName: 'Family Medical History',
                            fieldType: VALIDATION_TYPE.DESCRIPTIVE_TEXT,
                            isRequired: _hasFamilyHistory,
                          );
                        },
                        onChanged: (value) {
                          Provider.of<FormStateProvider>(context, listen: false)
                              .updateField('patient_information', 'family_history', value);
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'Have you traveled recently?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: AppStyles.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: _hasTraveled,
                      onChanged: (value) {
                        setState(() {
                          _hasTraveled = value;
                        });
                      },
                      title: Text(_hasTraveled ? 'Yes' : 'No'),
                      activeColor: AppStyles.accentColor,
                    ),
                    if (_hasTraveled) ...[
                      const SizedBox(height: 20),
                      _buildTextField(
                        context,
                        instructionalText: 'If yes, where and when?',
                        controller: _travelDetailsController,
                        labelText: 'Travel Details',
                        hintText: 'Enter travel details',
                        icon: Icons.flight,
                        validator: (value) {
                          return checkFieldValidation(
                            context: context,
                            val: value,
                            fieldName: 'Travel Details',
                            fieldType: VALIDATION_TYPE.DESCRIPTIVE_TEXT,
                            isRequired: _hasTraveled,
                          );
                        },
                        onChanged: (value) {
                          Provider.of<FormStateProvider>(context, listen: false)
                              .updateField('patient_information', 'travel_details', value);
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText: 'Can you describe your socioeconomic status? (e.g., financial or living situation)',
                      controller: _socioeconomicController,
                      labelText: 'Socioeconomic Status',
                      hintText: 'Enter socioeconomic status',
                      icon: Icons.home,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Socioeconomic Status',
                          fieldType: VALIDATION_TYPE.DESCRIPTIVE_TEXT,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('patient_information', 'socioeconomic', value);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      context,
                      instructionalText: 'What is your current or past occupation?',
                      controller: _occupationController,
                      labelText: 'Occupation',
                      hintText: 'Enter your occupation',
                      icon: Icons.work,
                      validator: (value) {
                        return checkFieldValidation(
                          context: context,
                          val: value,
                          fieldName: 'Occupation',
                          fieldType: VALIDATION_TYPE.TEXT,
                          isRequired: true,
                        );
                      },
                      onChanged: (value) {
                        Provider.of<FormStateProvider>(context, listen: false)
                            .updateField('patient_information', 'occupation', value);
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