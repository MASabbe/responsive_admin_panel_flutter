import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/pages/edit_profile_page.dart';

// Mock UserEntity
class MockUserEntity extends Mock implements UserEntity {}

// Mock AuthProvider
class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockUserEntity mockUser;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockUser = MockUserEntity();

    // Stub the mock user's properties
    when(() => mockUser.name).thenReturn('Test User');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.avatarUrl).thenReturn('http://example.com/avatar.png');

    // Stub the mock provider's properties
    when(() => mockAuthProvider.currentUser).thenReturn(mockUser);
    when(() => mockAuthProvider.isLoading).thenReturn(false);
    when(() => mockAuthProvider.errorMessage).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: const MaterialApp(
        home: EditProfilePage(),
      ),
    );
  }

  testWidgets('EditProfilePage should render initial widgets correctly', (widgetTester) async {
    await mockNetworkImages(() async {
      // Arrange
      await widgetTester.pumpWidget(createWidgetUnderTest());

      // Act & Assert
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Test User'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'test@example.com'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);

      // Verify that the user's avatar is displayed
      expect(find.byType(CircleAvatar), findsNWidgets(2)); // Main avatar + camera icon background
    });
  });

  testWidgets('should show loading indicator when saving', (widgetTester) async {
    await mockNetworkImages(() async {
      // Arrange
      when(() => mockAuthProvider.isLoading).thenReturn(true);

      // Act
      await widgetTester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save Changes'), findsNothing);
    });
  });

  // testWidgets('should call updateUserProfile when save button is tapped', (widgetTester) async {
  //   await mockNetworkImages(() async {
  //     // Arrange
  //     when(() => mockAuthProvider.updateUserProfile(any(), any())).thenAnswer((_) async {});
  //     await widgetTester.pumpWidget(createWidgetUnderTest());
  //
  //     // Act
  //     await widgetTester.tap(find.text('Save Changes'));
  //     await widgetTester.pump(); // Trigger the state change
  //
  //     // Assert
  //     verify(() => mockAuthProvider.updateUserProfile('Test User', null)).called(1);
  //   });
  // });
  //
  // testWidgets('should show error message if profile update fails', (widgetTester) async {
  //   await mockNetworkImages(() async {
  //     // Arrange
  //     const errorMessage = 'Failed to update';
  //     when(() => mockAuthProvider.updateUserProfile(any(), any())).thenAnswer((_) async {
  //       when(() => mockAuthProvider.errorMessage).thenReturn(errorMessage);
  //     });
  //
  //     await widgetTester.pumpWidget(createWidgetUnderTest());
  //
  //     // Act
  //     await widgetTester.tap(find.text('Save Changes'));
  //     await widgetTester.pumpAndSettle(); // Wait for snackbar
  //
  //     // Assert
  //     expect(find.text('Failed to update profile: $errorMessage'), findsOneWidget);
  //   });
  // });
}
