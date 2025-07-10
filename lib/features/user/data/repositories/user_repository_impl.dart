import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_list_result.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Future<UserListResult> getUsers({required int limit, DocumentSnapshot? startAfter}) async {
    Query query = _firestore.collection('users').orderBy('email').limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final querySnapshot = await query.get();
    final users = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return UserEntity.fromMap(doc.id, data);
    }).toList();

    return UserListResult(
      users: users,
      lastDocument: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
    );
  }

  @override
  Future<UserEntity> getUser(String userId) async {
    // In a real application, this would make a network request.
    // For this boilerplate, we return a dummy user.
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return UserEntity(
      id: userId,
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=$userId',
      role: 'Admin',
    );
  }
}
