import 'package:flutter/material.dart';

import '../../utils/app_styles.dart' as AppColors;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 24, color: AppColors.primaryColor)),
      ),
    );
  }
}