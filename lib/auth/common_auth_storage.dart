
import 'package:shared_preferences/shared_preferences.dart';

class CommonAuthStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _roleKey = 'role';
  static const String _teacherIdKey = 'teacher_id';

  static Future<void> saveLoginData({
    required String token,
    required int userId,
    required String username,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_roleKey, role.toUpperCase());
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<void> saveTeacherId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_teacherIdKey, id);
  }

  static Future<int?> getTeacherId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_teacherIdKey);
  }

  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_teacherIdKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
