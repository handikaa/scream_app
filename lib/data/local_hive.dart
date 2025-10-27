import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  final String _boxName = 'usersBox';

  Box get box => Hive.box(_boxName);

  Future<void> saveUser(Map<String, dynamic> userData) async {
    await box.put('user', userData);
  }

  Map<String, dynamic>? getUser() {
    final user = box.get('user');
    if (user != null) {
      return Map<String, dynamic>.from(user);
    }
    return null;
  }

  Future<void> clearUser() async {
    await box.delete('user');
  }

  bool hasUser() {
    return box.containsKey('user');
  }
}
