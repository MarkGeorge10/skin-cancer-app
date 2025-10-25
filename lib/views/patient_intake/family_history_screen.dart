import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/helper.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/intake_form.dart';
import '../widgets/intake_switch.dart';
import '../widgets/intake_text_field.dart';

class FamilyHistoryScreen extends StatefulWidget {
  final int step;
  const FamilyHistoryScreen({super.key, required this.step});

  @override
  State<FamilyHistoryScreen> createState() => _FamilyHistoryScreenState();
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final details = formProvider.formData['family_history']?['details'] ?? '';
    _detailsController = TextEditingController(text: details);

    _detailsController.addListener(() {
      formProvider.updateField('family_history', 'details', _detailsController.text);
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vis = Provider.of<ScreenVisibilityProvider>(context, listen: false);

    return Consumer<FormStateProvider>(
      builder: (context, form, child) {
        final d = form.formData['family_history'] ?? {};
        final hasHistory = d['has_history'] == 'true';

        return IntakeForm(
          formKey: GlobalKey<FormState>(),
          onBack: () {
            final prevScreen = vis.getPreviousScreen('family_history');
            if (prevScreen != null) {
              final prevStep = vis.getStepForScreen(prevScreen);
              context.go('/patient_intake/$prevScreen?step=$prevStep');
            } else {
              // Fallback if there's no previous screen (e.g., go to selection)
              context.go('/screen_selection');
            }
          },
          onNext: () => goNext(context, vis, 'family_history'),
          children: [
            IntakeSwitch(
              value: hasHistory,
              onChanged: (v) {
                form.updateField('family_history', 'has_history', v.toString());
                if (!v) {
                  _detailsController.clear();
                  form.updateField('family_history', 'details', '');
                }
              },
              title: 'Any family history of skin cancer?',
              child: hasHistory
                  ? IntakeTextField(
                controller: _detailsController,
                labelText: 'Details',
                hintText: 'e.g., Mother had melanoma',
                icon: Icons.family_restroom,
                maxLines: 3,
                validator: (v) => hasHistory && (v?.trim().isEmpty ?? true) ? 'Required' : null,
              )
                  : null,
            ),
          ],
        );
      },
    );
  }
}
