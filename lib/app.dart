import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_cancer_app/providers/app_providers.dart';
import 'package:skin_cancer_app/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skin Cancer App',
      theme: ThemeData(
        primaryColor: const Color(0xFF28895E),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF28895E),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
