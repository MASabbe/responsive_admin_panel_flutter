import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/theme_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/widgets/dashboard_card.dart';
import 'package:responsive_admin_panel_flutter/features/user/domain/entities/user_entity.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

class MockAuthProvider extends Mock implements AuthProvider {}
class MockUserEntity extends Mock implements UserEntity {}
class MockThemeProvider extends Mock implements ThemeProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockUserEntity mockUser;
  late MockThemeProvider mockThemeProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockUser = MockUserEntity();
    mockThemeProvider = MockThemeProvider();

    when(() => mockUser.name).thenReturn('Test User');
    when(() => mockUser.avatarUrl).thenReturn('http://example.com/avatar.png');
    when(() => mockAuthProvider.currentUser).thenReturn(mockUser);
    when(() => mockThemeProvider.isDarkMode).thenReturn(false);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: mockThemeProvider),
      ],
      child: const MaterialApp(
        home: DashboardPage(),
      ),
    );
  }

  testWidgets('DashboardPage should render initial widgets correctly', (widgetTester) async {
    await mockNetworkImages(() async {
      // Arrange
      widgetTester.view.physicalSize = const Size(1920, 1080);
      widgetTester.view.devicePixelRatio = 1.0;

      // Act
      await widgetTester.pumpWidget(createWidgetUnderTest());
      await widgetTester.pumpAndSettle();

      // Assert
      expect(find.text('Welcome back, Test User!'), findsOneWidget);

      // Verify Dashboard Cards specifically
      expect(find.widgetWithText(DashboardCard, 'Revenue'), findsOneWidget);
      expect(find.widgetWithText(DashboardCard, 'Expenses'), findsOneWidget);
      expect(find.widgetWithText(DashboardCard, 'Projects'), findsOneWidget);
      expect(find.widgetWithText(DashboardCard, 'Clients'), findsOneWidget);

      // Verify section titles, scrolling to them if they are not visible
      expect(find.text('Revenue Overview'), findsOneWidget);

      final scrollViewFinder = find.byType(CustomScrollView);
      await widgetTester.drag(scrollViewFinder, const Offset(0.0, -800));
      await widgetTester.pumpAndSettle();
      expect(find.text('Recent Projects'), findsOneWidget);

      await widgetTester.drag(scrollViewFinder, const Offset(0.0, -800));
      await widgetTester.pumpAndSettle();
      expect(find.text('Active Tasks'), findsOneWidget);
    });
  });
}
