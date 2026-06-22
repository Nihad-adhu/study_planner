import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  String? username;
  String? email;
  bool isLoggedIn = false;

  void login(String usernameVal, String emailVal) {
    username = usernameVal;
    email = emailVal;
    isLoggedIn = true;
    notifyListeners();
  }

  void register(String usernameVal, String emailVal) {
    username = usernameVal;
    email = emailVal;
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    username = null;
    email = null;
    isLoggedIn = false;
    notifyListeners();
  }

  void editProfile(String newUsername, String newEmail) {
    username = newUsername;
    email = newEmail;
    notifyListeners();
  }
}

// Global instance for legacy access (if needed, though Riverpod/Provider is better)
final AuthService authService = AuthService();
