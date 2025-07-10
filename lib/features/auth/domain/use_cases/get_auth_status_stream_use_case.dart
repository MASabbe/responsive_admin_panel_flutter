import 'package:responsive_admin_panel_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

class GetAuthStatusStreamUseCase {
  final AuthRepository repository;

  GetAuthStatusStreamUseCase(this.repository);

  Stream<UserEntity?> call() {
    return repository.authStateChanges;
  }
}
