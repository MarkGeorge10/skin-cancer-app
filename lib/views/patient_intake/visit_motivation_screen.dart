import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../utils/validation.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/intake_form.dart';
import '../widgets/intake_text_field.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/helper.dart'; // Assuming you have a helper for goNext
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/intake_form.dart';
import '../widgets/intake_text_field.dart';

class VisitMotivationScreen extends StatefulWidget {
  final int step;
  const VisitMotivationScreen({super.key, required this.step});

  @override
  State<VisitMotivationScreen> createState() => _VisitMotivationScreenState();
}

class _VisitMotivationScreenState extends State<VisitMotivationScreen> {
  late final TextEditingController _reasonController;
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    // Use listen: false in initState to read the initial value without subscribing.
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final initialData = formProvider.formData['visit_motivation'] ?? {};

    _reasonController = TextEditingController(text: initialData['reason'] ?? '');
    _detailsController = TextEditingController(text: initialData['details'] ?? '');

    // Add listeners to update the provider without causing a rebuild.
    _reasonController.addListener(() {
      formProvider.updateField('visit_motivation', 'reason', _reasonController.text);
    });
    _detailsController.addListener(() {
      formProvider.updateField('visit_motivation', 'details', _detailsController.text);
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No need to listen to formProvider here anymore, as controllers handle updates.
    final visProvider = Provider.of<ScreenVisibilityProvider>(context, listen: false);

    return IntakeForm(
      formKey: GlobalKey<FormState>(),
      onBack: () => context.go('/screen_selection'),
      onNext: () {
        final next = visProvider.getNextScreen('visit_motivation');
        if (next != null) {
          final step = visProvider.getStepForScreen(next);
          context.go('/patient_intake/$next?step=$step');
        }
      },
      children: [
        IntakeTextField(
          controller: _reasonController,
          // We no longer need onChanged here because the controller's listener handles it.
          labelText: 'Reason for Visit',
          hintText: 'e.g., new mole, itching',
          icon: Icons.info_outline,
          instructionalText: 'What is the primary reason for your visit today?',
          validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
        ),
        IntakeTextField(
          controller: _detailsController,
          // We no longer need onChanged here.
          labelText: 'Details',
          hintText: 'e.g., 1cm red raised lesion on left arm',
          icon: Icons.description,
          maxLines: 3,
          instructionalText: 'Provide details about location and appearance',
          validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
        ),
      ],
    );
  }
}
