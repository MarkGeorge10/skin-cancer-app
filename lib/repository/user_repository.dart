import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user/user_model.dart';

class UserRepository {
  static const String _userKey = 'current_user';

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);

    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final user = User.fromJson(json);

      // Check token expiry
      if (user.accessTokenExpiry.isBefore(DateTime.now())) {
        await clearUser(); // Token expired
        return null;
      }

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
