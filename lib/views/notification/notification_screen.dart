

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_styles.dart' as AppColors;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text('Notifications Screen', style: TextStyle(fontSize: 24, color: AppColors.primaryColor)),
      ),
    );
  }
}