import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_list_result.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<UserListResult> call({required int limit, DocumentSnapshot? startAfter}) {
    return repository.getUsers(limit: limit, startAfter: startAfter);
  }
}
