import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_list_result.dart';

/// Abstract repository for user related data operations.
abstract class UserRepository {
  /// Fetches a user by their ID.
  /// Throws an exception if the user is not found.
  Future<UserEntity> getUser(String userId);

  /// Fetches a list of users.
  Future<UserListResult> getUsers({required int limit, DocumentSnapshot? startAfter});
}