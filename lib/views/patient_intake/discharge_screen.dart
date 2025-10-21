import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_styles.dart';
import '../../utils/validation.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/auth_view_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class DischargeScreen extends StatefulWidget {
  final int step;
  const DischargeScreen({super.key, required this.step});

  @override
  State<DischargeScreen> createState() => _DischargeScreenState();
}

class _DischargeScreenState extends State<DischargeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dischargeDateController = TextEditingController();
  final _dischargeNotesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    _dischargeDateController.text = formProvider.formData['discharge']?['discharge_date'] ?? '';
    _dischargeNotesController.text = formProvider.formData['discharge']?['discharge_notes'] ?? '';
  }

  @override
  void dispose() {
    _dischargeDateController.dispose();
    _dischargeNotesController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    if (_formKey.currentState!.validate() && formProvider.validateForm()) {
      setState(() {
        _isSubmitting = true;
      });
      print(jsonEncode(formProvider.formData));
      context.go('/');
      // try {
      //   // Placeholder: Send formData to backend
      //   final response = await http.post(
      //     Uri.parse('YOUR_BACKEND_ENDPOINT'), // Replace with actual endpoint
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Authorization': 'Bearer ${authViewModel.currentUser?.accessToken ?? ''}',
      //     },
      //     body: jsonEncode(formProvider.formData),
      //   );
      //   if (response.statusCode == 200) {
      //     formProvider.submitForm();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: const Text('Patient intake completed successfully'),
      //         backgroundColor: AppStyles.accentColor,
      //       ),
      //     );
      //     context.go('/');
      //   } else {
      //     throw Exception('Failed to submit intake: ${response.body}');
      //   }
      // } catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Error submitting intake: $e'),
      //       backgroundColor: AppStyles.errorColor,
      //     ),
      //   );
      // } finally {
      //   setState(() {
      //     _isSubmitting = false;
      //   });
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please correct the errors in the form'),
          backgroundColor: AppStyles.errorColor,
        ),
      );
    }
  }

  void _back(BuildContext context) {
    context.go('/patient_intake/treatments?step=8');
  }

  List<Step> _buildSteps(BuildContext context) {
    final formProvider = Provider.of<FormStateProvider>(context);
    final steps = [
      Step(
        title: const Text('Visit Motivation'),
        state: formProvider.validateSection('visit_motivation') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 0,
        content: Container(),
      ),
      Step(
        title: const Text('Admission'),
        state: formProvider.validateSection('admission') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 1,
        content: Container(),
      ),
      Step(
        title: const Text('Patient Info'),
        state: formProvider.validateSection('patient_information') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 2,
        content: Container(),
      ),
      Step(
        title: const Text('Medical History'),
        state: formProvider.validateSection('patient_medical_history') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 3,
        content: Container(),
      ),
      Step(
        title: const Text('Surgeries'),
        state: formProvider.validateSection('surgeries') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 4,
        content: Container(),
      ),
      Step(
        title: const Text('Symptoms'),
        state: formProvider.validateSection('symptoms') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 5,
        content: Container(),
      ),
      Step(
        title: const Text('Examinations'),
        state: formProvider.validateSection('medical_examinations') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 6,
        content: Container(),
      ),
      Step(
        title: const Text('Diagnosis Tests'),
        state: formProvider.validateSection('diagnosis_tests') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 7,
        content: Container(),
      ),
      Step(
        title: const Text('Treatments'),
        state: formProvider.validateSection('treatments') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 8,
        content: Container(),
      ),
      Step(
        title: const Text('Discharge'),
        state: formProvider.validateSection('discharge') ? StepState.complete : StepState.indexed,
        isActive: widget.step == 9,
        content: Container(),
      ),
    ];
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discharge Information'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            // Stepper(
            //   type: StepperType.horizontal,
            //   currentStep: widget.step,
            //   steps: _buildSteps(context),
            //   onStepTapped: (index) {
            //     if (index <= widget.step || formProvider.validateSection(_getSectionName(index))) {
            //       context.go('/patient_intake/${_getRouteName(index)}?step=$index');
            //     }
            //   },
            //   controlsBuilder: (context, details) => Container(),
            // ),
            Expanded(
              child: Padding(
                padding: AppStyles.screenPadding,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        context,
                        controller: _dischargeDateController,
                        labelText: 'Discharge Date',
                        hintText: 'MM/DD/YYYY',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          final error = checkFieldValidation(
                            context: context,
                            val: value,
                            fieldName: 'Discharge Date',
                            fieldType: VALIDATION_TYPE.DATE,
                          );
                          formProvider.setValidationError('discharge', 'discharge_date', error);
                          return error;
                        },
                        onChanged: (value) {
                          formProvider.updateField('discharge', 'discharge_date', value);
                        },
                      ),
                      _buildTextField(
                        context,
                        controller: _dischargeNotesController,
                        labelText: 'Discharge Notes',
                        hintText: 'Enter discharge notes',
                        icon: Icons.description,
                        maxLines: 3,
                        validator: (value) {
                          final error = checkFieldValidation(
                            context: context,
                            val: value,
                            fieldName: 'Discharge Notes',
                            fieldType: VALIDATION_TYPE.DESCRIPTIVE_TEXT,
                          );
                          formProvider.setValidationError('discharge', 'discharge_notes', error);
                          return error;
                        },
                        onChanged: (value) {
                          formProvider.updateField('discharge', 'discharge_notes', value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomButton(
                              text: 'Back',
                              onPressed: () => _back(context),
                            ),
                          ),
                          Flexible(
                            child: CustomButton(
                              text: _isSubmitting ? 'Submitting...' : 'Submit Intake',
                              onPressed: _isSubmitting ? () {} : () => _submit(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      })



    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String labelText,
        required String hintText,
        required IconData icon,
        int? maxLines,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        ValueChanged<String>? onChanged,
      }) {
    return Padding(
      padding: AppStyles.fieldPadding,
      child: Row(
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
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  String _getSectionName(int index) {
    const sections = [
      'visit_motivation',
      'admission',
      'patient_information',
      'patient_medical_history',
      'surgeries',
      'symptoms',
      'medical_examinations',
      'diagnosis_tests',
      'treatments',
      'discharge',
    ];
    return sections[index];
  }

  String _getRouteName(int index) {
    const routes = [
      'visit_motivation',
      'admission',
      'patient_information',
      'patient_medical_history',
      'surgeries',
      'symptoms',
      'medical_examinations',
      'diagnosis_tests',
      'treatments',
      'discharge',
    ];
    return routes[index];
  }
}