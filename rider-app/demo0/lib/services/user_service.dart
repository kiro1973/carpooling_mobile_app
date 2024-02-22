// user_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../user.dart';
class UserService {
  
  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('users');

    if (data != null) {
      final List<dynamic> jsonData = json.decode(data);
      return jsonData.map((user) => User.fromJson(user)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(users.map((user) => user.toJson()).toList());
    prefs.setString('users', jsonData);
  }

  Future<void> registerUser(String username, String password) async {
    final List<User> users = await getUsers();
    final newUser = User(username: username, password: password);
    users.add(newUser);
    await saveUsers(users);
  }
}
