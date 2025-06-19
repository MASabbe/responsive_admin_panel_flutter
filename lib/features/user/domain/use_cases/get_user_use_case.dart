import '../entities/user_entity.dart';

class GetUserUseCase {
  Future<UserEntity> call(String userId) async {
    // Dummy implementation
    return UserEntity(
      id: userId,
      name: 'Dummy',
      email: 'dummy@example.com',
      avatarUrl: '',
      role: 'user',
    );
  }
}