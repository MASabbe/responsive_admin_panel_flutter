import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/get_auth_status_stream_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/update_user_profile_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

class AuthProvider with ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetAuthStatusStreamUseCase _getAuthStatusStreamUseCase;
  final SignUpUseCase _signUpUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  late final StreamSubscription<UserEntity?> _authSubscription;

  bool _isLoading = true;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthProvider({
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required GetAuthStatusStreamUseCase getAuthStatusStreamUseCase,
    required SignUpUseCase signUpUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  })  : _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _getAuthStatusStreamUseCase = getAuthStatusStreamUseCase,
        _signUpUseCase = signUpUseCase,
        _updateUserProfileUseCase = updateUserProfileUseCase {
    _initializeApp();
  }

  bool get isLoading => _isLoading;
  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  Future<void> _initializeApp() async {
    // Sign out any existing user to ensure a clean state on initialization.
    await signOut();
    // Now, start listening for authentication changes.
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = _getAuthStatusStreamUseCase().listen((user) {
      _currentUser = user;
      if (_isLoading) {
        _isLoading = false;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _signInUseCase(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      if (mounted) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _signUpUseCase(email, password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      if (mounted) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _signOutUseCase();
      _currentUser = null; // Explicitly set user to null on sign out
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateUserProfile(String name, File? image) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _updateUserProfileUseCase(name, image);
      // The auth stream will automatically provide the updated user data.
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  bool mounted = true;
}
