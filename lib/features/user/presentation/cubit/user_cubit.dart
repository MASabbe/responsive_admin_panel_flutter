import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/use_cases/get_user_use_case.dart';

class UserCubit extends Cubit<UserEntity?> {
  final GetUserUseCase getUserUseCase;
  UserCubit(this.getUserUseCase) : super(null);

  Future<void> fetchUser(String id) async {
    final user = await getUserUseCase(id);
    emit(user);
  }
}
