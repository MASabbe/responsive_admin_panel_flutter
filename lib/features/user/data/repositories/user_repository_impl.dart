import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_list_result.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  String? _getValidAvatarUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return url;
    }
    return null;
  }

  @override
  Future<UserListResult> getUsers({required int limit, DocumentSnapshot? startAfter}) async {
    Query query = _firestore.collection('users').orderBy('email').limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final querySnapshot = await query.get();
    final users = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return UserEntity(
        id: doc.id,
        name: data['name'],
        email: data['email'],
        role: data['role'],
        avatarUrl: _getValidAvatarUrl(data['avatarUrl']),
      );
    }).toList();

    return UserListResult(
      users: users,
      lastDocument: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
    );
  }

  @override
  Future<UserEntity> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data() as Map<String, dynamic>;
    return UserEntity(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      role: data['role'],
      avatarUrl: _getValidAvatarUrl(data['avatarUrl']),
    );
  }
}
