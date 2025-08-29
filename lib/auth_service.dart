import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyUsername = 'auth_username';
  static const String _keyPassword = 'auth_password';
  static const String _keyLoggedIn = 'auth_logged_in';

  static Future<bool> hasCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_keyUsername) ?? '').isNotEmpty &&
        (prefs.getString(_keyPassword) ?? '').isNotEmpty;
  }

  static Future<void> saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
  }

  static Future<bool> validate(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString(_keyUsername) ?? '';
    final savedPass = prefs.getString(_keyPassword) ?? '';
    return username == savedUser && password == savedPass;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }
}


