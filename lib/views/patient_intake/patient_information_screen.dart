import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/helper.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/intake_form.dart';
import '../widgets/intake_text_field.dart';

class PatientInformationScreen extends StatefulWidget {
  final int step;
  const PatientInformationScreen({super.key, required this.step});

  @override
  State<PatientInformationScreen> createState() => _PatientInformationScreenState();
}

// --- Options for Dropdowns ---
const List<String> _sexOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
const List<String> _ethnicityOptions = [
  'Caucasian', 'Hispanic', 'African American', 'Asian', 'Native American', 'Pacific Islander', 'Other'
];

class _PatientInformationScreenState extends State<PatientInformationScreen> {
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final data = formProvider.formData['patient_information'] ?? {};

    _ageController = TextEditingController(text: data['age'] ?? '');

    _ageController.addListener(() {
      // Add silent: true to prevent unnecessary rebuilds
      formProvider.updateField('patient_information', 'age', _ageController.text, silent: true);
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vis = Provider.of<ScreenVisibilityProvider>(context, listen: false);
    // Use Consumer to get the latest form data for dropdowns
    return Consumer<FormStateProvider>(
      builder: (context, form, child) {
        final data = form.formData['patient_information'] ?? {};
        final selectedSex = data['sex']?.isNotEmpty == true ? data['sex'] : null;
        final selectedEthnicity = data['ethnicity']?.isNotEmpty == true ? data['ethnicity'] : null;

        return IntakeForm(
          formKey: GlobalKey<FormState>(),
          onBack: () {
            final prevScreen = vis.getPreviousScreen('patient_information');
            if (prevScreen != null) {
              final prevStep = vis.getStepForScreen(prevScreen);
              context.go('/patient_intake/$prevScreen?step=$prevStep');
            } else {
              // Fallback if there's no previous screen (e.g., go to selection)
              context.go('/screen_selection');
            }
          },
          onNext: () => goNext(context, vis, 'patient_information'),
          children: [
            IntakeTextField(
              controller: _ageController,
              labelText: 'Age',
              hintText: 'e.g., 35',
              icon: Icons.cake,
              keyboardType: TextInputType.number,
              validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            // --- Sex Dropdown ---
            DropdownButtonFormField<String>(
              value: selectedSex,
              items: _sexOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => form.updateField('patient_information', 'sex', v),
              decoration: const InputDecoration(
                labelText: 'Sex',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wc),
              ),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            // --- Ethnicity Dropdown ---
            DropdownButtonFormField<String>(
              value: selectedEthnicity,
              items: _ethnicityOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => form.updateField('patient_information', 'ethnicity', v),
              decoration: const InputDecoration(
                labelText: 'Ethnicity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.public),
              ),
              validator: (v) => v == null ? 'Required' : null,
            ),
          ],
        );
      },
    );
  }
}
