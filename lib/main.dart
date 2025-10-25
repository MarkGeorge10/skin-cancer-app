import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_cancer_app/providers/app_providers.dart';
import 'package:skin_cancer_app/router.dart';
import 'package:skin_cancer_app/view_model/bottom_nav_provider.dart';
import 'package:skin_cancer_app/view_model/form_state_provider.dart';
import 'package:skin_cancer_app/view_model/screen_visibility_provider.dart';
import '../view_model/auth_view_model.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize repositories and view model
    final authRepo = AuthRepository();
    final userRepo = UserRepository();
    final authVM = AuthViewModel(authRepo, userRepo);

    // Wait for user data to load from storage (e.g., SharedPreferences, secure storage)
    await authVM.loadUser();

    runApp(
      MultiProvider(
        providers: [
          Provider<AuthRepository>(create: (_) => authRepo),
          Provider<UserRepository>(create: (_) => userRepo),
          ChangeNotifierProvider<AuthViewModel>.value(value: authVM),
          ChangeNotifierProvider<BottomNavProvider>(
            create: (_) => BottomNavProvider(),
          ),
          ChangeNotifierProvider<FormStateProvider>(
            create: (_) => FormStateProvider(),
          ),
          ChangeNotifierProvider<ScreenVisibilityProvider>(
            create: (_) => ScreenVisibilityProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    // Log initialization errors (you can replace with your logging solution)
    debugPrint('Error initializing app: $e\n$stackTrace');
    // Run app with minimal setup to show an error screen or fallback
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Failed to initialize app: $e',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
