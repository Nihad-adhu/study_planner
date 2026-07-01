part of 'app_state_provider.dart';

extension AuthState on StudyAppState {
  // ── Auth Delegation ──
  String? get username => authService.username;
  String? get email => authService.email;
  bool get isLoggedIn => authService.isLoggedIn;

  Future<void> signInWithGoogle() async {
    await authService.signInWithGoogle();
    refresh();
  }

  Future<void> login(String emailVal, String passwordVal) async {
    await authService.login(emailVal, passwordVal);
    refresh();
  }

  Future<void> register(
    String usernameVal,
    String emailVal,
    String passwordVal,
  ) async {
    await authService.register(usernameVal, emailVal, passwordVal);
    refresh();
  }

  Future<void> logout() async {
    await authService.logout();
    refresh();
  }

  Future<void> editProfile(String newUsername, String newEmail) async {
    await authService.editProfile(newUsername, newEmail);
    refresh();
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await authService.changePassword(currentPassword, newPassword);
    refresh();
  }

  Future<void> deleteAccount(String password) async {
    await authService.deleteAccount(password);
    refresh();
  }
}
