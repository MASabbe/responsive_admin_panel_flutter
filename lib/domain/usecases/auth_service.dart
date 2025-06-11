import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_panel_flutter/data/models/user_model.dart';

class AuthService extends ChangeNotifier {
  bool _isLoading = false;
  User? _currentUser;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null) {
        _currentUser = User.fromJson(jsonDecode(userData));
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Attempts to sign in a user with the provided email and password.
  ///
  /// This function simulates an API call with a delay and checks if the provided
  /// credentials match the demo credentials. If successful, it sets the current
  /// user and authentication status, and stores the user data in shared preferences.
  ///
  /// Returns `true` if sign-in is successful, otherwise returns `false`.
  /// Notifies listeners when the loading state changes.
  ///
  /// [email] The email address of the user attempting to sign in.
  /// [password] The password of the user attempting to sign in.
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulasi panggilan API dengan delay
      await Future.delayed(const Duration(seconds: 2));

      // Di implementasi nyata, Anda akan mengganti ini dengan panggilan API
      if (email == 'demo@example.com' && password == 'password') {
        final user = User(
          id: '123',
          name: 'Demo User',
          email: email,
          avatarUrl: 'https://ui-avatars.com/api/?name=Demo+User&background=random',
          role: 'Admin',
        );

        _currentUser = user;
        _isAuthenticated = true;

        // Simpan data user
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(user.toJson()));

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');

      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      debugPrint('Error signing out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

