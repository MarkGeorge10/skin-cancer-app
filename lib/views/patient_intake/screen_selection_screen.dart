import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/custom_button.dart';

class ScreenSelectionScreen extends StatelessWidget {
  const ScreenSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visibilityProvider = Provider.of<ScreenVisibilityProvider>(context);
    debugPrint('Building ScreenSelectionScreen');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Intake Screens'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          debugPrint('ScreenSelectionScreen constraints: $constraints');
          return SingleChildScrollView(
            child: Padding(
              padding: AppStyles.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Choose which screens to include in the patient intake flow:',
                    style: TextStyle(fontSize: 16, color: AppStyles.secondaryTextColor),
                  ),
                  const SizedBox(height: 16),
                  ...visibilityProvider.screenVisibility.keys.map((screen) {
                    return SwitchListTile(
                      value: visibilityProvider.screenVisibility[screen]!,
                      onChanged: (value) {
                        visibilityProvider.toggleScreen(screen, value);
                      },
                      title: Text(
                        _getScreenTitle(screen),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      activeColor: AppStyles.accentColor,
                    );
                  }),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Start Intake',
                    onPressed: () {
                      final enabledScreens = visibilityProvider.getEnabledScreens();
                      if (enabledScreens.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please enable at least one screen'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                        return;
                      }
                      final firstScreen = enabledScreens.first;
                      final step = visibilityProvider.getStepForScreen(firstScreen);
                      context.go('/patient_intake/$firstScreen?step=$step');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getScreenTitle(String screen) {
    const titles = {
      'visit_motivation': 'Visit Motivation',
      'admission': 'Admission',
      'patient_information': 'Patient Information',
      'patient_medical_history': 'Patient Medical History',
      'surgeries': 'Surgeries',
      'symptoms': 'Symptoms',
      'medical_examinations': 'Medical Examinations',
      'diagnosis_tests': 'Diagnosis Tests',
      'treatments': 'Treatments',
      'discharge': 'Discharge',
    };
    return titles[screen] ?? screen;
  }
}