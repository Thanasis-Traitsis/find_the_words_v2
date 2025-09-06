import 'package:find_the_words/core/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  static AuthService get instance => _instance;

  Future<bool> userHasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppKeys.authTokenKey) != null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppKeys.authTokenKey);
  }

  Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(AppKeys.authTokenKey, token);
  }

  Future<bool> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(AppKeys.authTokenKey);
  }
}
