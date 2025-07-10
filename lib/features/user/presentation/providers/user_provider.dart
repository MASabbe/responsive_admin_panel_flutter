import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/use_cases/get_users_use_case.dart';

class UserProvider with ChangeNotifier {
  final GetUsersUseCase getUsersUseCase;

  UserProvider({required this.getUsersUseCase});

  List<UserEntity> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  List<UserEntity> get users => _users;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchUsers({int limit = 10}) async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await getUsersUseCase(limit: limit, startAfter: _lastDocument);
      _users.addAll(result.users);
      _lastDocument = result.lastDocument;
      _hasMore = result.users.length == limit;
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _users = [];
    _isLoading = false;
    _hasMore = true;
    _lastDocument = null;
    notifyListeners();
  }
}
