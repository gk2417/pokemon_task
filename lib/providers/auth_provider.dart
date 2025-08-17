import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _authService.authStateChanges.listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

 void logout() async {
  await FirebaseAuth.instance.signOut();
  _user = null;
  notifyListeners();
}

}