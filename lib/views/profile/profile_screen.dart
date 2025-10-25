import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: const Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 24, color: AppStyles.primaryColor)),
      ),
    );
  }
}