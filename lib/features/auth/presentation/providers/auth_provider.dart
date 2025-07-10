import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  String? _getValidAvatarUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return url;
    }
    return null;
  }

  void _onAuthChanged(UserEntity? user) {
    //TODO: Tak tambahin check user id di sini
    //Check if the user is authenticated and has a valid ID before updating the state.
    if (user != null && user.id.isNotEmpty) {
      final validAvatarUrl = _getValidAvatarUrl(user.avatarUrl);
      _currentUser = UserEntity(
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        avatarUrl: validAvatarUrl,
      );
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> _initializeApp() async {
    // Sign out any existing user to ensure a clean state on initialization.
    // Now, start listening for authentication changes.
    _listenToAuthChanges();
    Timer(const Duration(seconds: 2), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  void _listenToAuthChanges() {
    _authSubscription = _getAuthStatusStreamUseCase().listen(_onAuthChanged);
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _signInUseCase(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unknown error occurred.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signUp(
      String email, String password, String name, File? avatar) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Only pass email and password to signUpUseCase
      await _signUpUseCase(email, password);
      // After sign up, update the user profile with name, email and avatar
      await _updateUserProfileUseCase(name, email, avatar);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unknown error occurred.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _signOutUseCase();
      _currentUser = null; // Explicitly set user to null on sign out
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unknown error occurred.';
    } finally {
      if (mounted) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateUserProfile(String email, String name, File? image) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _updateUserProfileUseCase(name, email,image);
      // The auth stream will automatically provide the updated user data.
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unknown error occurred.';
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
