import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../common/preferences/preferences_manager.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _subscription;

  AuthRefreshNotifier() {
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  bool get isLoggedIn {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    return true;
  }

  bool get isEmailVerified =>
      FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  String get rememberedEmail =>
      PreferencesManager().getString('remembered_email') ?? '';

  bool get isRememberMeChecked =>
      PreferencesManager().getBool('rememberMe') ?? false;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}