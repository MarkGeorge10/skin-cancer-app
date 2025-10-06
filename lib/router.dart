import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skin_cancer_app/views/auth/register_screen.dart';
import 'package:skin_cancer_app/views/chat/chat_screen.dart';
import 'package:skin_cancer_app/views/home/home_screen.dart';
import 'package:skin_cancer_app/views/master_screen.dart';
import 'package:skin_cancer_app/views/notification/notification_screen.dart';
import 'package:skin_cancer_app/views/profile/profile_screen.dart';
import 'package:skin_cancer_app/views/auth/login_screen.dart';
import 'package:skin_cancer_app/view_model/auth_view_model.dart';

import 'package:skin_cancer_app/views/auth/register_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final isLoggedIn = authViewModel.isLoggedIn;

    final goingToLogin = state.matchedLocation == '/login';
    final goingToSignup = state.matchedLocation == '/signup';

    print("isLoggedIn: ${isLoggedIn} ");
    print("goingToLogin: ${goingToLogin} ");
    print("goingToSignup: ${goingToSignup} ");


    if (!isLoggedIn && !goingToLogin && !goingToSignup) return '/login';
    if (isLoggedIn && (goingToLogin || goingToSignup)) return '/';
    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MasterScreen(),
      routes: [
        GoRoute(path: 'home', builder: (context, state) => const HomeScreen()),
        GoRoute(path: 'chat', builder: (context, state) => const ChatScreen()),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/signup', // <-- Add this
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
