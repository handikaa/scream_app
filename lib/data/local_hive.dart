import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  final String _boxName = 'usersBox';

  Box get box => Hive.box(_boxName);

  Future<void> addUser(Map<String, dynamic> user) async {
    await box.add(user);
  }

  List<Map<String, dynamic>> getAllUsers() {
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  bool isUserExist(String name, String phone) {
    final users = getAllUsers();
    return users.any(
      (u) => u['phone'] == phone,
    );
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}
