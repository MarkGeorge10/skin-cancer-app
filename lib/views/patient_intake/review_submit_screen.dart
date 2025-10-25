import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/helper.dart'; // Make sure helper is imported if goNext uses it
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart'; // 1. Import the provider
import '../widgets/intake_form.dart';

class ReviewSubmitScreen extends StatelessWidget {
  final int step;
  const ReviewSubmitScreen({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormStateProvider>(context);
    // 2. Get the visibility provider
    final visProvider = Provider.of<ScreenVisibilityProvider>(context, listen: false);

    // Convert the form data map to a more readable string for display.
    final formDataString = formProvider.formData.entries
        .map((entry) => '${entry.key}:\n${_formatMap(entry.value)}')
        .join('\n\n');

    return IntakeForm(
      // 3. Update the onBack logic
      onBack: () {
        final prevScreen = visProvider.getPreviousScreen('review_submit');
        if (prevScreen != null) {
          final prevStep = visProvider.getStepForScreen(prevScreen);
          context.go('/patient_intake/$prevScreen?step=$prevStep');
        } else {
          // Fallback if there's no previous screen (e.g., go to selection)
          context.go('/screen_selection');
        }
      },
      // The "Next" button becomes a "Submit" button here.
      onNext: () {
        // Implement your submission logic here, e.g., send to a server.
        print("Submitting form...");
        print(formProvider.formData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );
        // Optionally, navigate away after submission
        context.go('/screen_selection'); // Navigate after submit
      },
      nextButtonText: 'Submit',
      formKey: GlobalKey<FormState>(),
      children: [
        const Text(
          'Review Your Information',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            formDataString,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }

  // Helper to format nested maps for display.
  String _formatMap(Map<String, dynamic> map) {
    return map.entries.map((e) => '  - ${e.key}: ${e.value}').join('\n');
  }
}
