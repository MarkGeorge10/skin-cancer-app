import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../view_model/screen_visibility_provider.dart';

void goNext(BuildContext context, ScreenVisibilityProvider vis, String current) {
  final next = vis.getNextScreen(current);
  if (next != null) {
    print('/patient_intake/$next?step=${vis.getStepForScreen(next)}');
    context.go('/patient_intake/$next?step=${vis.getStepForScreen(next)}');
  } else {
    context.go('/');
  }
}