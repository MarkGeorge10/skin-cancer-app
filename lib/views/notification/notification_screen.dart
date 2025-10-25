

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: const Center(
        child: Text('Notifications Screen', style: TextStyle(fontSize: 24, color: AppStyles.primaryColor)),
      ),
    );
  }
}