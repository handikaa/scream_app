import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static const String _keyLevel = 'selected_level';

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
}
