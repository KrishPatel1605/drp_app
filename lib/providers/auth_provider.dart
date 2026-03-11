import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String? login(String email, String password) {
    if (email == "test@test.com" && password == "123456") {
      _isLoggedIn = true;
      notifyListeners();
      return null;
    } else {
      return "Invalid email or password";
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}