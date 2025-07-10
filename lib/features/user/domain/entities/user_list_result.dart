import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

class UserListResult {
  final List<UserEntity> users;
  final DocumentSnapshot? lastDocument;

  UserListResult({required this.users, this.lastDocument});
}
