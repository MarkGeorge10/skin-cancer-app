import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:skin_cancer_app/view_model/auth_view_model.dart';
import 'package:skin_cancer_app/view_model/screen_visibility_provider.dart';

import 'package:skin_cancer_app/views/auth/login_screen.dart';
import 'package:skin_cancer_app/views/auth/register_screen.dart';
import 'package:skin_cancer_app/views/home/home_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/SkinTypeSunExposureScreen.dart';
import 'package:skin_cancer_app/views/patient_intake/review_submit_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/screen_selection_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/surgeries_screen.dart';

// Import only the screens used in the new flow
import 'package:skin_cancer_app/views/patient_intake/visit_motivation_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/patient_information_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/family_history_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/patient_medical_history_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/symptoms_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Root → redirect based on auth
    GoRoute(
      path: '/',
      redirect: (context, state) {
        // final authVM = Provider.of<AuthViewModel>(context, listen: false);
        // if (authVM.currentUser == null) return '/login';

        // Go directly to the screen selection for testing
        return '/screen_selection';
      },
    ),

    // Auth
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: '/signup',
      builder: (_, __) => const RegisterScreen(),
      // redirect: (context, state) {
      //   final authVM = Provider.of<AuthViewModel>(context, listen: false);
      //   return authVM.currentUser != null ? '/screen_selection' : null;
      // },
    ),

    // Screen Selection
    GoRoute(
      path: '/screen_selection',
      builder: (_, __) => const ScreenSelectionScreen(),
      // redirect: (context, state) {
      //   final authVM = Provider.of<AuthViewModel>(context, listen: false);
      //   return authVM.currentUser == null ? '/login' : null;
      // },
    ),

    // Patient Intake Flow
    GoRoute(
      path: '/patient_intake',
      redirect: (context, state) {
        // final authVM = Provider.of<AuthViewModel>(context, listen: false);
        final visibility = Provider.of<ScreenVisibilityProvider>(context, listen: false);

        // if (authVM.currentUser == null) return '/login';

        // Only redirect if at base path
        if (state.uri.path == '/patient_intake') {
          final enabled = visibility.getEnabledScreens();
          if (enabled.isEmpty) return '/screen_selection';
          final first = enabled.first;
          final step = visibility.getStepForScreen(first);
          return '/patient_intake/$first?step=$step';
        }
        return null;
      },
      routes: [
        _intakeRoute('visit_motivation', (s) => VisitMotivationScreen(step: _step(s))),
        _intakeRoute('patient_information', (s) => PatientInformationScreen(step: _step(s))),
        _intakeRoute('skin_type_sun', (s) => SkinTypeSunExposureScreen(step: _step(s))),
        _intakeRoute('family_history', (s) => FamilyHistoryScreen(step: _step(s))),
        _intakeRoute('patient_medical_history', (s) => PatientMedicalHistoryScreen(step: _step(s))),
        _intakeRoute('symptoms', (s) => SymptomsScreen(step: _step(s))),
        _intakeRoute('surgeries', (s) => SurgeriesScreen(step: _step(s))),
        _intakeRoute('review_submit', (s) => ReviewSubmitScreen(step: _step(s))),
      ],
    ),

    // Fallback
    GoRoute(
      path: '/error',
      builder: (_, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      ),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Error: ${state.error}')),
  ),
);

/// Helper to reduce boilerplate
GoRoute _intakeRoute(String path, Widget Function(GoRouterState) builder) {
  return GoRoute(
    path: path,
    builder: (context, state) => builder(state),
  );
}

/// Extract step from query params
int _step(GoRouterState state) {
  return int.tryParse(state.uri.queryParameters['step'] ?? '0') ?? 0;
}
