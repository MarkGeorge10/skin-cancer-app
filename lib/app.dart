import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_cancer_app/providers/app_providers.dart';
import 'package:skin_cancer_app/router.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_cancer_app/router.dart';
import 'package:skin_cancer_app/utils/app_styles.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skin Cancer App',
      theme: ThemeData(
        primaryColor: AppStyles.accentColor, // Matches AppStyles.accentColor (0xFF28895E)
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppStyles.accentColor,
          secondary: AppStyles.secondaryColor, // Assuming defined in AppStyles
          error: AppStyles.errorColor, // Matches error color for validation
          surface: AppStyles.inputFillColor(context), // For input backgrounds
        ),
        scaffoldBackgroundColor: AppStyles.backgroundColor, // Consistent background
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: AppStyles.primaryTextColor),
          labelMedium: const TextStyle(color: AppStyles.secondaryTextColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppStyles.inputFillColor(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppStyles.accentColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppStyles.errorColor, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.accentColor,
            foregroundColor: Colors.white,
            padding: AppStyles.buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false, // Disable debug banner in production
      restorationScopeId: 'skin_cancer_app', // For state restoration
      routerConfig: appRouter,
    );
  }
}
