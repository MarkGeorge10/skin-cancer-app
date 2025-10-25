import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/helper.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/intake_form.dart';

class SurgeriesScreen extends StatelessWidget {
  final int step;
  const SurgeriesScreen({super.key, required this.step});

  // Helper to add a new item
  void _addItem(FormStateProvider form) {
    final List<Map<String, dynamic>> currentList = List.from(form.formData['surgeries']?['history'] ?? []);
    currentList.add({'name': '', 'year': ''});
    form.updateField('surgeries', 'history', currentList);
  }

  // Helper to remove an item
  void _removeItem(FormStateProvider form, int index) {
    final List<Map<String, dynamic>> currentList = List.from(form.formData['surgeries']?['history'] ?? []);
    currentList.removeAt(index);
    form.updateField('surgeries', 'history', currentList);
  }

  // Helper to update an item's text
  void _updateItem(FormStateProvider form, int index, String key, String value) {
    final List<Map<String, dynamic>> currentList = List.from(form.formData['surgeries']?['history'] ?? []);
    currentList[index][key] = value;
    form.updateField('surgeries', 'history', currentList, silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final vis = Provider.of<ScreenVisibilityProvider>(context, listen: false);

    return Consumer<FormStateProvider>(
      builder: (context, form, child) {
        final List<dynamic> surgeries = form.formData['surgeries']?['history'] ?? [];

        return IntakeForm(
          formKey: GlobalKey<FormState>(),
          onBack: () {
            final prevScreen = vis.getPreviousScreen('surgeries');
            if (prevScreen != null) {
              final prevStep = vis.getStepForScreen(prevScreen);
              context.go('/patient_intake/$prevScreen?step=$prevStep');
            } else {
              // Fallback if there's no previous screen (e.g., go to selection)
              context.go('/screen_selection');
            }
          },
          onNext: () => goNext(context, vis, 'surgeries'),
          children: [
            Text(
              'Please list any past surgeries',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (surgeries.isEmpty)
              const Center(child: Text('No surgeries added.')),
            ...List.generate(surgeries.length, (index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Surgery #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeItem(form, index),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: surgeries[index]['name'],
                        decoration: const InputDecoration(labelText: 'Surgery Name'),
                        onChanged: (val) => _updateItem(form, index, 'name', val),
                        validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: surgeries[index]['year'],
                        decoration: const InputDecoration(labelText: 'Year of Surgery'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => _updateItem(form, index, 'year', val),
                        validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              );
            }),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Surgery'),
                onPressed: () => _addItem(form),
              ),
            ),
          ],
        );
      },
    );
  }
}
