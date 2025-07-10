import 'package:responsive_admin_panel_flutter/features/user/domain/repositories/user_repository.dart';
import '../entities/user_entity.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<UserEntity> call(String userId) async {
    return await repository.getUser(userId);
  }
}