import 'package:responsive_admin_panel_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<UserEntity> call(String email, String password) {
    return _repository.signUpWithEmailAndPassword(email, password);
  }
}
