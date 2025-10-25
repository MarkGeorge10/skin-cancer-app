import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/helper.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/intake_form.dart';
import '../widgets/intake_switch.dart';
import '../widgets/intake_text_field.dart';

class PatientMedicalHistoryScreen extends StatefulWidget {
  final int step;
  const PatientMedicalHistoryScreen({super.key, required this.step});

  @override
  State<PatientMedicalHistoryScreen> createState() => _PatientMedicalHistoryScreenState();
}

class _PatientMedicalHistoryScreenState extends State<PatientMedicalHistoryScreen> {
  late final TextEditingController _smokingController;

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final d = formProvider.formData['medical_history'] ?? {};
    _smokingController = TextEditingController(text: d['smoking_history'] ?? '');

    _smokingController.addListener(() {
      formProvider.updateField('medical_history', 'smoking_history', _smokingController.text);
    });
  }

  @override
  void dispose() {
    _smokingController.dispose();
    super.dispose();
  }

  // Helper to add a new item to a list in the provider
  void _addItem(FormStateProvider form, String key) {
    final List<Map<String, dynamic>> currentList = List.from(form.formData['medical_history']?[key] ?? []);
    currentList.add({'value': ''});
    form.updateField('medical_history', key, currentList);
  }

  // Helper to remove an item
  void _removeItem(FormStateProvider form, String key, int index) {
    final List<Map<String, dynamic>> currentList = List.from(form.formData['medical_history']?[key] ?? []);
    currentList.removeAt(index);
    form.updateField('medical_history', key, currentList);
  }

  // Helper to update an item's text
  void _updateItem(FormStateProvider form, String key, int index, String value) {
    final List<Map<String, dynamic>> currentList = List.from(form.formData['medical_history']?[key] ?? []);
    currentList[index]['value'] = value;
    // No need to call updateField here, as it's handled by the listener in a real scenario
    // For simplicity, we can update it directly.
    form.updateField('medical_history', key, currentList, silent: true); // silent update
  }

  @override
  Widget build(BuildContext context) {
    final vis = Provider.of<ScreenVisibilityProvider>(context, listen: false);

    return Consumer<FormStateProvider>(
      builder: (context, form, child) {
        final d = form.formData['patient_medical_history'] ?? {};
        final hasCond = d['has_conditions'] == 'true';
        final hasAllergies = d['has_allergies'] == 'true';

        // Get the lists
        final List<dynamic> conditions = d['conditions'] ?? [];
        final List<dynamic> allergies = d['allergies'] ?? [];

        return IntakeForm(
          formKey: GlobalKey<FormState>(),
          onBack: () {
            final prevScreen = vis.getPreviousScreen('patient_medical_history');
            if (prevScreen != null) {
              final prevStep = vis.getStepForScreen(prevScreen);
              context.go('/patient_intake/$prevScreen?step=$prevStep');
            } else {
              // Fallback if there's no previous screen (e.g., go to selection)
              context.go('/screen_selection');
            }
          },
          onNext: () => goNext(context, vis, 'patient_medical_history'),
          children: [
            // --- Medical Conditions ---
            IntakeSwitch(
              value: hasCond,
              onChanged: (v) => form.updateField('medical_history', 'has_conditions', v.toString()),
              title: 'Any existing medical conditions?',
              child: hasCond
                  ? _buildDynamicList(
                form: form,
                list: conditions,
                listKey: 'conditions',
                hintText: 'e.g., Hypertension',
                icon: Icons.local_hospital,
              )
                  : null,
            ),
            // --- Allergies ---
            IntakeSwitch(
              value: hasAllergies,
              onChanged: (v) => form.updateField('medical_history', 'has_allergies', v.toString()),
              title: 'Any known allergies?',
              child: hasAllergies
                  ? _buildDynamicList(
                form: form,
                list: allergies,
                listKey: 'allergies',
                hintText: 'e.g., Penicillin',
                icon: Icons.warning_amber,
              )
                  : null,
            ),
            // --- Smoking History ---
            IntakeTextField(
              controller: _smokingController,
              labelText: 'Smoking History',
              hintText: 'e.g., Never, Former, Current',
              icon: Icons.smoking_rooms,
            ),
          ],
        );
      },
    );
  }

  // Widget builder for the dynamic list
  Widget _buildDynamicList({
    required FormStateProvider form,
    required List<dynamic> list,
    required String listKey,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      children: [
        ...List.generate(list.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: list[index]['value'],
                    onChanged: (val) => _updateItem(form, listKey, index, val),
                    decoration: InputDecoration(
                      hintText: hintText,
                      prefixIcon: Icon(icon),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () => _removeItem(form, listKey, index),
                ),
              ],
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add More'),
            onPressed: () => _addItem(form, listKey),
          ),
        )
      ],
    );
  }
}
