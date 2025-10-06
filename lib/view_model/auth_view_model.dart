// lib/view_model/auth_view_model.dart
import 'package:flutter/cupertino.dart';
import '../data/response/api_response.dart';
import '../model/user/register_user_request.dart';
import '../model/user/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final UserRepository _userRepository;

  AuthViewModel(this._repository, this._userRepository) {
    // Fire-and-forget: load persisted user on VM creation.
    loadUser();
  }

  ApiResponse<User> _registrationState = ApiResponse.empty();
  ApiResponse<User> get registrationState => _registrationState;

  ApiResponse<User> _loginState = ApiResponse.empty();
  ApiResponse<User> get loginState => _loginState;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  User? _currentUser;
  User? get currentUser => _currentUser;


  /// Load login state from storage
  Future<void> loadUser() async {
    final user = await _userRepository.getCurrentUser();
    print('Loaded user: $user');
    if (user != null) {
      _currentUser = user;
      _isLoggedIn = true;
      _scheduleLogout(user.accessTokenExpiry);
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  void _scheduleLogout(DateTime expiry) {
    final duration = expiry.difference(DateTime.now());
    Future.delayed(duration, () {
      logout();
      // Don't show SnackBar here — just update state
      notifyListeners(); // UI can react to state change
    });
  }



  /// Save user and update state
  Future<void> _setUser(User user) async {
    _currentUser = user;
    await _userRepository.saveUser(user);
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Logout

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    await _userRepository.clearUser();
    notifyListeners();
  }

  /// Register new user
  Future<void> register(
      String email,
      String password,
      String name, {
        Function(String)? onError,
      }) async {
    _registrationState = ApiResponse.loading();
    notifyListeners();

    final request = RegisterUserRequest(
      email: email,
      password: password,
      name: name,
    );

    final result = await _repository.register(request);
    _registrationState = result;
    notifyListeners();

    if (result.status == Status.completed && result.data != null) {
      await _setUser(result.data!);
    } else if (result.status == Status.error && onError != null) {
      onError(result.message ?? 'Unknown error');
    }
  }

  /// Login existing user
  Future<void> login(
      String email,
      String password, {
        Function(String)? onError,
      }) async {
    _loginState = ApiResponse.loading();
    notifyListeners();

    final user = await _repository.login(email, password);
    _loginState = user;
    notifyListeners();

    if (user.status == Status.completed && user.data != null) {

      await _setUser(user.data!);
      _scheduleLogout(user.data!.accessTokenExpiry);
    } else if (user.status == Status.error && onError != null) {
      onError(user.message ?? 'Invalid email or password');
    }
  }

}
