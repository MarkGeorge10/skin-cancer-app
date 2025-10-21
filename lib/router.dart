import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:skin_cancer_app/view_model/auth_view_model.dart';
import 'package:skin_cancer_app/view_model/screen_visibility_provider.dart';
import 'package:skin_cancer_app/views/auth/login_screen.dart';
import 'package:skin_cancer_app/views/auth/register_screen.dart';
import 'package:skin_cancer_app/views/home/home_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/admission_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/diagnosis_tests_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/discharge_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/medical_examinations_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/patient_information_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/patient_medical_history_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/screen_selection_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/surgeries_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/symptoms_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/treatments_screen.dart';
import 'package:skin_cancer_app/views/patient_intake/visit_motivation_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) {
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        debugPrint('Root redirect: currentUser=${authVM.currentUser}');
        if (authVM.currentUser == null) {
          debugPrint('Root redirect: Navigating to /login');
          return '/login';
        }
        debugPrint('Root redirect: Navigating to /screen_selection');
        return '/screen_selection';
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const RegisterScreen(),
      redirect: (context, state) {
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        debugPrint('Signup redirect: currentUser=${authVM.currentUser}');
        if (authVM.currentUser != null) {
          debugPrint('Signup redirect: Navigating to /screen_selection');
          return '/screen_selection';
        }
        debugPrint('Signup redirect: Staying on /signup');
        return null;
      },
    ),
    GoRoute(
      path: '/screen_selection',
      builder: (context, state) => const ScreenSelectionScreen(),
      redirect: (context, state) {
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        // debugPrint('ScreenSelection redirect: currentUser=${authVM.currentUser}');
        // if (authVM.currentUser == null) {
        //   debugPrint('ScreenSelection redirect: Navigating to /login');
        //   return '/login';
        // }
        debugPrint('ScreenSelection redirect: Staying on /screen_selection');
        return null;
      },
    ),
    GoRoute(
      path: '/patient_intake',
      redirect: (context, state) {
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        final visibilityProvider = Provider.of<ScreenVisibilityProvider>(context, listen: false);
        debugPrint('PatientIntake redirect: currentUser=${authVM.currentUser}, enabledScreens=${visibilityProvider.getEnabledScreens()}, uri=${state.uri}');
        // if (authVM.currentUser == null) {
        //   debugPrint('PatientIntake redirect: Navigating to /login');
        //   return '/login';
        // }
        // Only redirect if the path is exactly '/patient_intake'
        if (state.uri.path == '/patient_intake') {
          final enabledScreens = visibilityProvider.getEnabledScreens();
          if (enabledScreens.isEmpty) {
            debugPrint('PatientIntake redirect: No enabled screens, navigating to /screen_selection');
            return '/screen_selection';
          }
          final firstScreen = enabledScreens.first;
          final step = visibilityProvider.getStepForScreen(firstScreen);
          debugPrint('PatientIntake redirect: Navigating to /patient_intake/$firstScreen?step=$step');
          return '/patient_intake/$firstScreen?step=$step';
        }
        debugPrint('PatientIntake redirect: No redirect needed for ${state.uri.path}');
        return null;
      },
      routes: [
        GoRoute(
          path: 'visit_motivation',
          builder: (context, state) => VisitMotivationScreen(
            step: int.parse(state.uri.queryParameters['step'] ?? '0'),
          ),
        ),
        GoRoute(
          path: 'admission',
          builder: (context, state) => AdmissionScreen(
            step: int.parse(state.uri.queryParameters['step'] ?? '1'),
          ),
        ),
        GoRoute(
          path: 'patient_information',
          builder: (context, state) => PatientInformationScreen(
            step: int.parse(state.uri.queryParameters['step'] ?? '2'),
          ),
        ),
        // GoRoute(
        //   path: 'patient_medical_history',
        //   builder: (context, state) => PatientMedicalHistoryScreen(
        //     step: int.parse(state.uri.queryParameters['step'] ?? '3'),
        //   ),
        // ),
        // GoRoute(
        //   path: 'surgeries',
        //   builder: (context, state) => SurgeriesScreen(
        //     step: int.parse(state.uri.queryParameters['step'] ?? '4'),
        //   ),
        // ),
        // GoRoute(
        //   path: 'symptoms',
        //   builder: (context, state) => SymptomsScreen(
        //     step: int.parse(state.uri.queryParameters['step'] ?? '5'),
        //   ),
        // ),
        // GoRoute(
        //   path: 'medical_examinations',
        //   builder: (context, state) => MedicalExaminationsScreen(
        //     step: int.parse(state.uri.queryParameters['step'] ?? '6'),
        //   ),
        // ),
        // GoRoute(
        //   path: 'diagnosis_tests',
        //   builder: (context, state) => DiagnosisTestsScreen(
        //     step: int.parse(state.uri.queryParameters['step'] ?? '7'),
        //   ),
        // ),
        // GoRoute(
        //   path: 'treatments',
        //   builder: (context, state) => TreatmentsScreen(
        //     step: int.parse(state.uri.queryParameters['step'] ?? '8'),
        //   ),
        // ),
        // GoRoute(
        //   path: 'discharge',
        //   builder: (context, state) => DischargeScreen(
        //     step: int.parse(state.uri.queryParameters['step'] ?? '9'),
        //   ),
        // ),
      ],
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.uri}'),
        ),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);