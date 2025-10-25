// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_styles.dart';
// import '../../utils/validation.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_checkbox_list_tile.dart';
// import '../widgets/custom_text_field.dart';
// import '../../view_model/form_state_provider.dart';
// import 'package:go_router/go_router.dart';
//
// class DiagnosisTestsScreen extends StatefulWidget {
//   final int step;
//   const DiagnosisTestsScreen({super.key, required this.step});
//
//   @override
//   State<DiagnosisTestsScreen> createState() => _DiagnosisTestsScreenState();
// }
//
// class _DiagnosisTestsScreenState extends State<DiagnosisTestsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _testNameController = TextEditingController();
//   final _testResultsController = TextEditingController();
//   final _testDateController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final formProvider = Provider.of<FormStateProvider>(context, listen: false);
//     _testNameController.text = formProvider.formData['diagnosis_tests']?['test_name'] ?? '';
//     _testResultsController.text = formProvider.formData['diagnosis_tests']?['test_results'] ?? '';
//     _testDateController.text = formProvider.formData['diagnosis_tests']?['test_date'] ?? '';
//   }
//
//   @override
//   void dispose() {
//     _testNameController.dispose();
//     _testResultsController.dispose();
//     _testDateController.dispose();
//     super.dispose();
//   }
//
//   void _next(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       context.go('/patient_intake/treatments?step=8');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Please correct the errors in the form'),
//           backgroundColor: AppStyles.errorColor,
//         ),
//       );
//     }
//   }
//
//   void _back(BuildContext context) {
//     context.go('/patient_intake/medical_examinations?step=6');
//   }
//
//   List<Step> _buildSteps(BuildContext context) {
//     final formProvider = Provider.of<FormStateProvider>(context);
//     final steps = [
//       Step(
//         title: const Text('Visit Motivation'),
//         state: formProvider.validateSection('visit_motivation') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 0,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Admission'),
//         state: formProvider.validateSection('admission') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 1,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Patient Info'),
//         state: formProvider.validateSection('patient_information') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 2,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Medical History'),
//         state: formProvider.validateSection('patient_medical_history') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 3,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Surgeries'),
//         state: formProvider.validateSection('surgeries') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 4,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Symptoms'),
//         state: formProvider.validateSection('symptoms') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 5,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Examinations'),
//         state: formProvider.validateSection('medical_examinations') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 6,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Diagnosis Tests'),
//         state: formProvider.validateSection('diagnosis_tests') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 7,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Treatments'),
//         state: formProvider.validateSection('treatments') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 8,
//         content: Container(),
//       ),
//       Step(
//         title: const Text('Discharge'),
//         state: formProvider.validateSection('discharge') ? StepState.complete : StepState.indexed,
//         isActive: widget.step == 9,
//         content: Container(),
//       ),
//     ];
//     return steps;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final formProvider = Provider.of<FormStateProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Diagnosis Tests'),
//       ),
//       body: LayoutBuilder(
//           builder: (context, constraints) {
//             debugPrint('Scaffold body constraints: $constraints');
//
//             return     Column(
//               children: [
//                 // Stepper(
//                 //   type: StepperType.horizontal,
//                 //   currentStep: widget.step,
//                 //   steps: _buildSteps(context),
//                 //   onStepTapped: (index) {
//                 //     if (index <= widget.step || formProvider.validateSection(_getSectionName(index))) {
//                 //       context.go('/patient_intake/${_getRouteName(index)}?step=$index');
//                 //     }
//                 //   },
//                 //   controlsBuilder: (context, details) => Container(),
//                 // ),
//                 Expanded(
//                   child: Padding(
//                     padding: AppStyles.screenPadding,
//                     child: Form(
//                       key: _formKey,
//                       child: ListView(
//                         children: [
//                           _buildTextField(
//                             context,
//                             controller: _testNameController,
//                             labelText: 'Test Name',
//                             hintText: 'Enter test name',
//                             icon: Icons.science,
//                             validator: (value) {
//                               final error = checkFieldValidation(
//                                 context: context,
//                                 val: value,
//                                 fieldName: 'Test Name',
//                                 fieldType: VALIDATION_TYPE.TEXT,
//                               );
//                               formProvider.setValidationError('diagnosis_tests', 'test_name', error);
//                               return error;
//                             },
//                             onChanged: (value) {
//                               formProvider.updateField('diagnosis_tests', 'test_name', value);
//                             },
//                           ),
//                           _buildTextField(
//                             context,
//                             controller: _testResultsController,
//                             labelText: 'Test Results',
//                             hintText: 'Enter test results',
//                             icon: Icons.description,
//                             maxLines: 3,
//                             validator: (value) {
//                               final error = checkFieldValidation(
//                                 context: context,
//                                 val: value,
//                                 fieldName: 'Test Results',
//                                 fieldType: VALIDATION_TYPE.DESCRIPTIVE_TEXT,
//                               );
//                               formProvider.setValidationError('diagnosis_tests', 'test_results', error);
//                               return error;
//                             },
//                             onChanged: (value) {
//                               formProvider.updateField('diagnosis_tests', 'test_results', value);
//                             },
//                           ),
//                           _buildTextField(
//                             context,
//                             controller: _testDateController,
//                             labelText: 'Test Date',
//                             hintText: 'MM/DD/YYYY',
//                             icon: Icons.calendar_today,
//                             keyboardType: TextInputType.datetime,
//                             validator: (value) {
//                               final error = checkFieldValidation(
//                                 context: context,
//                                 val: value,
//                                 fieldName: 'Test Date',
//                                 fieldType: VALIDATION_TYPE.DATE,
//                               );
//                               formProvider.setValidationError('diagnosis_tests', 'test_date', error);
//                               return error;
//                             },
//                             onChanged: (value) {
//                               formProvider.updateField('diagnosis_tests', 'test_date', value);
//                             },
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Flexible(
//                                 child: CustomButton(
//                                   text: 'Back',
//                                   onPressed: () => _back(context),
//                                 ),
//                               ),
//                               Flexible(
//                                 child: CustomButton(
//                                   text: 'Next',
//                                   onPressed: () => _next(context),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           })
//
//
//
//     );
//   }
//
//   Widget _buildTextField(
//       BuildContext context, {
//         required TextEditingController controller,
//         required String labelText,
//         required String hintText,
//         required IconData icon,
//         int? maxLines,
//         TextInputType? keyboardType,
//         String? Function(String?)? validator,
//         ValueChanged<String>? onChanged,
//       }) {
//     return Padding(
//       padding: AppStyles.fieldPadding,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppStyles.inputFillColor(context),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: AppStyles.secondaryTextColor),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: CustomTextField(
//               controller: controller,
//               labelText: labelText,
//               hintText: hintText,
//               maxLines: maxLines,
//               keyboardType: keyboardType,
//               validator: validator,
//               onChanged: onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getSectionName(int index) {
//     const sections = [
//       'visit_motivation',
//       'admission',
//       'patient_information',
//       'patient_medical_history',
//       'surgeries',
//       'symptoms',
//       'medical_examinations',
//       'diagnosis_tests',
//       'treatments',
//       'discharge',
//     ];
//     return sections[index];
//   }
//
//   String _getRouteName(int index) {
//     const routes = [
//       'visit_motivation',
//       'admission',
//       'patient_information',
//       'patient_medical_history',
//       'surgeries',
//       'symptoms',
//       'medical_examinations',
//       'diagnosis_tests',
//       'treatments',
//       'discharge',
//     ];
//     return routes[index];
//   }
// }
