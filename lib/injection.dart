import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_admin_panel_flutter/core/storage/secure_storage_service.dart';
import 'package:responsive_admin_panel_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/get_auth_status_stream_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/domain/use_cases/update_user_profile_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/team_provider.dart';
import 'package:responsive_admin_panel_flutter/features/user/data/repositories/user_repository_impl.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/use_cases/get_users_use_case.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/providers/user_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Providers
  sl.registerFactory<UserProvider>(() => UserProvider(getUsersUseCase: sl<GetUsersUseCase>()));
  sl.registerLazySingleton<AuthProvider>(() => AuthProvider(
        signInUseCase: sl<SignInUseCase>(),
        signOutUseCase: sl<SignOutUseCase>(),
        getAuthStatusStreamUseCase: sl<GetAuthStatusStreamUseCase>(),
        signUpUseCase: sl<SignUpUseCase>(),
        updateUserProfileUseCase: sl<UpdateUserProfileUseCase>(),
      ));
  sl.registerLazySingleton<TeamProvider>(() => TeamProvider());

  // Use Cases
  sl.registerLazySingleton<GetUsersUseCase>(() => GetUsersUseCase(sl<UserRepository>()));
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<GetAuthStatusStreamUseCase>(() => GetAuthStatusStreamUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<UpdateUserProfileUseCase>(() => UpdateUserProfileUseCase(sl<AuthRepository>()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl<FirebaseFirestore>()));
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<firebase_auth.FirebaseAuth>()),
  );

  // Core & External
  sl.registerLazySingleton<firebase_auth.FirebaseAuth>(
        () => firebase_auth.FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<SecureStorageService>(
        () => SecureStorageServiceImpl(sl<FlutterSecureStorage>()),
  );
}
