import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/helper.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/intake_form.dart';
import '../widgets/intake_checkbox_group.dart';
import '../widgets/intake_text_field.dart';

class SymptomsScreen extends StatefulWidget {
  final int step;
  const SymptomsScreen({super.key, required this.step});

  static const _options = [
    'New mole', 'Changing mole', 'Itching', 'Bleeding', 'Pain',
    'Scaling', 'Ulcer', 'Asymmetry', 'Irregular border', 'Multiple colors'
  ];

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  late final TextEditingController _locationController;
  late final TextEditingController _onsetController;
  late final TextEditingController _severityController;
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final d = formProvider.formData['symptoms'] ?? {};

    _locationController = TextEditingController(text: d['location'] ?? '');
    _onsetController = TextEditingController(text: d['onset'] ?? '');
    _severityController = TextEditingController(text: d['severity'] ?? '');
    _detailsController = TextEditingController(text: d['details'] ?? '');

    _locationController.addListener(() {
      formProvider.updateField('symptoms', 'location', _locationController.text, silent: true);
    });
    _onsetController.addListener(() {
      formProvider.updateField('symptoms', 'onset', _onsetController.text, silent: true);
    });
    _severityController.addListener(() {
      formProvider.updateField('symptoms', 'severity', _severityController.text, silent: true);
    });
    _detailsController.addListener(() {
      formProvider.updateField('symptoms', 'details', _detailsController.text, silent: true);
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _onsetController.dispose();
    _severityController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vis = Provider.of<ScreenVisibilityProvider>(context, listen: false);

    return Consumer<FormStateProvider>(
      builder: (context, form, child) {
        // Corrected the key from 'surgeries' to 'symptoms'
        final d = form.formData['symptoms'] ?? {};
        final selected = List<String>.from(d['selected'] ?? []);

        return IntakeForm(
          formKey: GlobalKey<FormState>(),
          onBack: () {
            final prevScreen = vis.getPreviousScreen('symptoms');
            if (prevScreen != null) {
              final prevStep = vis.getStepForScreen(prevScreen);
              context.go('/patient_intake/$prevScreen?step=$prevStep');
            } else {
              // Fallback if there's no previous screen (e.g., go to selection)
              context.go('/screen_selection');
            }
          },
          onNext: () {
            if (selected.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select at least one symptom')),
              );
              return;
            }
            // Corrected the onNext key to be its own screen
            goNext(context, vis, 'symptoms');
          },
          children: [
            IntakeCheckboxGroup(
              title: 'Select all symptoms that apply',
              options: SymptomsScreen._options,
              selected: selected,
              onChanged: (list) => form.updateField('symptoms', 'selected', list),
            ),
            IntakeTextField(
              controller: _locationController,
              labelText: 'Location',
              hintText: 'e.g., left forearm',
              icon: Icons.location_on,
              validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
            ),
            IntakeTextField(
              controller: _onsetController,
              labelText: 'When noticed',
              hintText: 'e.g., 3 months ago',
              icon: Icons.calendar_today,
              validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
            ),
            IntakeTextField(
              controller: _severityController,
              labelText: 'Severity',
              hintText: 'Mild / Moderate / Severe',
              icon: Icons.trending_up,
              validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
            ),
            IntakeTextField(
              controller: _detailsController,
              labelText: 'Details',
              hintText: 'Changes, triggers...',
              icon: Icons.note,
              maxLines: 3,
            ),
          ],
        );
      },
    );
  }
}
