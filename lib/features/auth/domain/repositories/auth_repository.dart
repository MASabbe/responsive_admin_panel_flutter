import 'dart:io';

import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

/// Abstract repository for authentication related operations.
abstract class AuthRepository {
  /// Stream to notify about changes in the authentication state.
  /// Emits the [UserEntity] if authenticated, or `null` if not.
  Stream<UserEntity?> get authStateChanges;

  /// Signs in a user with the given email and password.
  /// Returns the [UserEntity] on success.
  /// Throws an exception on failure.
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);

  /// Signs out the current user.
  Future<void> signOut();

  /// Signs up a new user with the given email and password.
  /// Returns the [UserEntity] on success.
  /// Throws an exception on failure.
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password);

  /// Gets the current authenticated user.
  /// Returns [UserEntity] if a user is signed in, otherwise returns `null`.
  Future<UserEntity?> getCurrentUser();

  /// Updates the user's profile information.
  /// 
  /// [name] - The new name of the user.
  /// [avatar] - The new avatar of the user.
  Future<void> updateUserProfile(String name, File? avatar);
}
