import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl(this._firebaseAuth);

  // Helper to convert Firebase User to our UserEntity
  UserEntity _userFromFirebase(firebase_auth.User? user) {
    if (user == null) {
      return UserEntity(
        id: '',
        email: '',
        name: '',
        avatarUrl: '',
        role: '',
      );
    }
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'No Name',
      avatarUrl: user.photoURL ?? '',
      role: 'user', // Role would typically come from a separate user profile service
    );
  }

  @override
  Stream<UserEntity> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _userFromFirebase(userCredential.user);
      if (user.id.isEmpty) {
        throw Exception('Sign in failed: User data not available.');
      }
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors
      throw Exception('Failed to sign in: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred during sign in.');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _userFromFirebase(userCredential.user);
      if (user.id.isEmpty) {
        throw Exception('Sign up failed: User data not available.');
      }
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors, e.g., email-already-in-use
      throw Exception('Failed to sign up: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred during sign up.');
    }
  }

  @override
  Future<void> updateUserProfile(String name, File? avatar) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    String? avatarUrl;
    if (avatar != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final avatarRef = storageRef.child('user_avatars/${user.uid}');
      await avatarRef.putFile(avatar);
      avatarUrl = await avatarRef.getDownloadURL();
    }

    await user.updateProfile(displayName: name, photoURL: avatarUrl ?? user.photoURL);

    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    });
  }
}
