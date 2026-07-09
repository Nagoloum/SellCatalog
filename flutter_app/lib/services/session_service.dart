import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SessionService {
  static const String _userKey = 'current_user';

  Future<void> saveUser(AppUser user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<AppUser?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    final rawUser = preferences.getString(_userKey);

    if (rawUser == null) {
      return null;
    }

    return AppUser.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userKey);
  }
}
