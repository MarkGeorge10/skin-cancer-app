import 'package:flutter/material.dart';

import '../../utils/app_styles.dart' as AppColors;


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text('Chat Screen', style: TextStyle(fontSize: 24, color: AppColors.primaryColor)),
      ),
    );
  }
}