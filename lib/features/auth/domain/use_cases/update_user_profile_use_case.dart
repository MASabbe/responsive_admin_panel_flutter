import 'dart:io';
import 'package:responsive_admin_panel_flutter/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserProfileUseCase {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> call(String email,String name, File? avatar) {
    return repository.updateUserProfile(name, avatar);
  }
}
