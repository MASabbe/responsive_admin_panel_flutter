import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/shared/presentation/providers/team_provider.dart';
import 'features/user/domain/use_cases/get_user_use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Providers
  sl.registerLazySingleton<AuthProvider>(() => AuthProvider());
  sl.registerLazySingleton<TeamProvider>(() => TeamProvider());

  // Use Cases
  sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase());

  // External
  sl.registerLazySingleton<Dio>(() => Dio());
  // Tambahkan dependency lain sesuai kebutuhan
}
