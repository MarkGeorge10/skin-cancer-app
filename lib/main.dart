import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_cancer_app/providers/app_providers.dart';
import 'package:skin_cancer_app/router.dart';
import 'package:skin_cancer_app/view_model/bottom_nav_provider.dart';
import '../view_model/auth_view_model.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authRepo = AuthRepository();
  final userRepo = UserRepository();
  final authVM = AuthViewModel(authRepo, userRepo);

  await authVM.loadUser(); // <-- wait until persisted user is loaded

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => authRepo),
        Provider<UserRepository>(create: (_) => userRepo),
        ChangeNotifierProvider<AuthViewModel>.value(value: authVM),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (_) => BottomNavProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
