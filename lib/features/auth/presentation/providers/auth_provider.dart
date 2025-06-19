import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_panel_flutter/features/dashboard/data/models/user_model.dart'
    as model;
import 'package:dio/dio.dart';
import 'package:responsive_admin_panel_flutter/core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  model.User? _currentUser;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;

  model.User? get currentUser => _currentUser;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> initialize() async {
    _isLoading = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null) {
        _currentUser = model.User.fromJson(jsonDecode(userData));
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
    } finally {
      _isLoading = false;
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
      final dio = Dio();
      final response = await dio.post(
        '${AppConstants.baseUrl}v1/api/auth/login',
        data: {
          'email': email,
          'password': password,
          'deviceInfo': 'deviceInfo',
          'osInfo': 'osInfo',
          'fcmToken': 'fcmToken',
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        final user = model.User(
          id: response.data['data']['id']?.toString() ?? '',
          name: response.data['data']['name'] ?? '',
          email: response.data['data']['email'] ?? '',
          avatarUrl: response.data['data']['avatarUrl'] ?? '',
          role: response.data['data']['role'] ?? '',
        );
        _currentUser = user;
        _isAuthenticated = true;
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
