import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstract interface for a secure storage service.
/// This allows for easy mocking and dependency injection.
abstract class SecureStorageService {
  /// Saves the authentication token securely.
  Future<void> saveToken(String token);

  /// Retrieves the authentication token.
  /// Returns null if the token is not found.
  Future<String?> getToken();

  /// Deletes the authentication token.
  Future<void> deleteToken();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl(this._storage);

  static const _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
