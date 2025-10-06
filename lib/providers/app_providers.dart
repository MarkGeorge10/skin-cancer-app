import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/bottom_nav_provider.dart';

List<SingleChildWidget> get providers => [
  Provider<AuthRepository>(create: (_) => AuthRepository()),
  Provider<UserRepository>(create: (_) => UserRepository()),
  ChangeNotifierProvider<AuthViewModel>(
    create: (context) => AuthViewModel(
      context.read<AuthRepository>(),
      context.read<UserRepository>(),
    ),
  ),

  ChangeNotifierProvider<BottomNavProvider>(
    create: (_) => BottomNavProvider(),
  ),
];
