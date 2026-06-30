import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  static bool isFirebaseInitialized = false;

  FirebaseAuth get _auth {
    if (!isFirebaseInitialized) {
      throw StateError('Firebase has not been initialized. Please check your configuration.');
    }
    return FirebaseAuth.instance;
  }

  AuthService() {
    if (isFirebaseInitialized) {
      try {
        _auth.userChanges().listen((User? user) {
          notifyListeners();
        });
      } catch (e) {
        debugPrint('[AuthService] Failed to listen to user changes: $e');
      }
    }
  }

  String? get username {
    if (!isFirebaseInitialized) return null;
    try {
      return _auth.currentUser?.displayName;
    } catch (_) {
      return null;
    }
  }

  String? get email {
    if (!isFirebaseInitialized) return null;
    try {
      return _auth.currentUser?.email;
    } catch (_) {
      return null;
    }
  }

  bool get isLoggedIn {
    if (!isFirebaseInitialized) return false;
    try {
      return _auth.currentUser != null;
    } catch (_) {
      return false;
    }
  }

  /// Sign in with email and password
  Future<void> login(String emailVal, String passwordVal) async {
    if (!isFirebaseInitialized) {
      throw StateError('Firebase is not initialized. Sign-in cannot proceed.');
    }
    await _auth.signInWithEmailAndPassword(
      email: emailVal,
      password: passwordVal,
    );
  }

  /// Register user and update displayName
  Future<void> register(String usernameVal, String emailVal, String passwordVal) async {
    if (!isFirebaseInitialized) {
      throw StateError('Firebase is not initialized. Registration cannot proceed.');
    }
    final UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: emailVal,
      password: passwordVal,
    );
    await credential.user?.updateDisplayName(usernameVal);
    await credential.user?.reload();
  }

  /// Sign in with Google Credential
  Future<void> signInWithGoogle() async {
    if (!isFirebaseInitialized) {
      throw StateError('Firebase is not initialized. Google Sign-In cannot proceed.');
    }
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } else {
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google Sign-In was cancelled by the user.',
      );
    }
  }

  /// Log out from both Firebase and Google Sign-In sessions
  Future<void> logout() async {
    if (!isFirebaseInitialized) return;
    await _auth.signOut();
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      debugPrint('[AuthService] Error signing out GoogleSignIn: $e');
    }
  }

  /// Edit Profile (DisplayName and Email updates)
  Future<void> editProfile(String newUsername, String newEmail) async {
    if (!isFirebaseInitialized) return;
    final user = _auth.currentUser;
    if (user != null) {
      if (newUsername != user.displayName) {
        await user.updateDisplayName(newUsername);
      }
      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }
      await user.reload();
      notifyListeners();
    }
  }

  /// Change Password with Re-authentication using the user's current password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    if (!isFirebaseInitialized) return;
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } else {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found.',
      );
    }
  }

  /// Delete Account with Re-authentication using user's password
  Future<void> deleteAccount(String password) async {
    if (!isFirebaseInitialized) return;
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
    } else {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found.',
      );
    }
  }
}

// Global instance for legacy access
final AuthService authService = AuthService();
