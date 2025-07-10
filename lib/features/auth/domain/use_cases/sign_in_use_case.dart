import 'package:responsive_admin_panel_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}
