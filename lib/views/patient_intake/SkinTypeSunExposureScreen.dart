import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../utils/helper.dart';
import '../../view_model/form_state_provider.dart';
import '../../view_model/screen_visibility_provider.dart';
import '../widgets/intake_form.dart';
import '../widgets/intake_switch.dart';
import '../widgets/intake_text_field.dart';

class SkinTypeSunExposureScreen extends StatefulWidget {
  final int step;
  const SkinTypeSunExposureScreen({super.key, required this.step});

  @override
  State<SkinTypeSunExposureScreen> createState() => _SkinTypeSunExposureScreenState();
}

class _SkinTypeSunExposureScreenState extends State<SkinTypeSunExposureScreen> {
  late final TextEditingController _sunDetailsController;
  late final TextEditingController _tanningDetailsController;
  late final TextEditingController _sunscreenDetailsController;

  @override
  void initState() {
    super.initState();
    final formProvider = Provider.of<FormStateProvider>(context, listen: false);
    final d = formProvider.formData['skin_sun'] ?? {};

    _sunDetailsController = TextEditingController(text: d['sun_details'] ?? '');
    _tanningDetailsController = TextEditingController(text: d['tanning_details'] ?? '');
    _sunscreenDetailsController = TextEditingController(text: d['sunscreen_details'] ?? '');

    _sunDetailsController.addListener(() {
      formProvider.updateField('skin_sun', 'sun_details', _sunDetailsController.text);
    });
    _tanningDetailsController.addListener(() {
      formProvider.updateField('skin_sun', 'tanning_details', _tanningDetailsController.text);
    });
    _sunscreenDetailsController.addListener(() {
      formProvider.updateField('skin_sun', 'sunscreen_details', _sunscreenDetailsController.text);
    });
  }

  @override
  void dispose() {
    _sunDetailsController.dispose();
    _tanningDetailsController.dispose();
    _sunscreenDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a Consumer for widgets that need to rebuild
    final vis = Provider.of<ScreenVisibilityProvider>(context, listen: false);

    return Consumer<FormStateProvider>(
      builder: (context, form, child) {
        final d = form.formData['skin_sun'] ?? {};
        final skinType = d['skin_type'] ?? 'I';
        final sun = d['significant_sun'] == 'true';
        final tanning = d['tanning_beds'] == 'true';
        final sunscreen = d['uses_sunscreen'] == 'true';

        return IntakeForm(
          formKey: GlobalKey<FormState>(),
          onBack: () {
            final prevScreen = vis.getPreviousScreen('skin_type_sun');
            if (prevScreen != null) {
              final prevStep = vis.getStepForScreen(prevScreen);
              context.go('/patient_intake/$prevScreen?step=$prevStep');
            } else {
              // Fallback if there's no previous screen (e.g., go to selection)
              context.go('/screen_selection');
            }
          },
          onNext: () => goNext(context, vis, 'skin_type_sun'),
          children: [
            const Text('Fitzpatrick Skin Type', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: skinType,
              items: ['I', 'II', 'III', 'IV', 'V', 'VI']
                  .map((s) => DropdownMenuItem(value: s, child: Text('Type $s')))
                  .toList(),
              onChanged: (v) => form.updateField('skin_sun', 'skin_type', v),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            IntakeSwitch(
              value: sun,
              onChanged: (v) => form.updateField('skin_sun', 'significant_sun', v.toString()),
              title: 'Significant lifetime sun exposure?',
              child: sun
                  ? IntakeTextField(
                controller: _sunDetailsController,
                labelText: 'Details',
                hintText: 'e.g., outdoor job',
                icon: Icons.wb_sunny,
              )
                  : null,
            ),
            IntakeSwitch(
              value: tanning,
              onChanged: (v) => form.updateField('skin_sun', 'tanning_beds', v.toString()),
              title: 'Used tanning beds?',
              child: tanning
                  ? IntakeTextField(
                controller: _tanningDetailsController,
                labelText: 'Frequency',
                hintText: 'e.g., 2x/month',
                icon: Icons.bedtime,
              )
                  : null,
            ),
            IntakeSwitch(
              value: sunscreen,
              onChanged: (v) => form.updateField('skin_sun', 'uses_sunscreen', v.toString()),
              title: 'Use sunscreen regularly?',
              child: sunscreen
                  ? IntakeTextField(
                controller: _sunscreenDetailsController,
                labelText: 'SPF & Frequency',
                hintText: 'e.g., SPF 50, daily',
                icon: Icons.shield,
              )
                  : null,
            ),
          ],
        );
      },
    );
  }
}