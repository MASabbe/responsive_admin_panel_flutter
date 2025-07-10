import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/use_cases/get_user_use_case.dart';

// Create a mock class for the repository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserUseCase(mockUserRepository);
  });

  const tUserId = '1';
  final tUserEntity = UserEntity(
    id: tUserId,
    name: 'Test User',
    email: 'test@example.com',
    avatarUrl: '',
    role: 'user',
  );

  test('should get user from the repository', () async {
    // Arrange
    // Stub the repository method to return a specific user when called with any string
    when(() => mockUserRepository.getUser(any())).thenAnswer((_) async => tUserEntity);

    // Act
    final result = await usecase(tUserId);

    // Assert
    expect(result, tUserEntity);
    // Verify that the getUser method was called exactly once with the correct user ID
    verify(() => mockUserRepository.getUser(tUserId)).called(1);
    // Verify that no other interactions happened with the mock repository
    verifyNoMoreInteractions(mockUserRepository);
  });
}
