import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static const String _keyLevel = 'selected_level';
  static const String _keyTimer = 'set_timer';

  static Future<void> saveLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLevel, level);
  }

  static Future<String?> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLevel);
  }

  static Future<void> clearLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLevel);
  }

  static Future<void> saveTimer(int timer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTimer, timer);
  }

  static Future<int?> getTimer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTimer);
  }

  static Future<void> clearTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTimer);
  }
}
