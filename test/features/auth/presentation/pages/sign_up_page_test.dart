import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/pages/sign_up_page.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/routes/route_names.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockAuthProvider mockAuthProvider;
  late GoRouter mockGoRouter;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    when(() => mockAuthProvider.isLoading).thenReturn(false);
    when(() => mockAuthProvider.errorMessage).thenReturn(null);

    mockGoRouter = GoRouter(
      initialLocation: RouteNames.signup,
      routes: [
        GoRoute(path: RouteNames.signup, builder: (context, state) => const SignUpPage()),
        GoRoute(
          path: RouteNames.dashboard,
          builder: (context, state) => const Scaffold(body: Text('Dashboard')),
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) => const Scaffold(body: Text('Sign In')),
        ),
      ],
    );
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: MaterialApp.router(
        routerConfig: mockGoRouter,
      ),
    );
  }

  testWidgets('SignUpPage should render initial widgets correctly', (widgetTester) async {
    // Arrange
    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pumpAndSettle();

    // Assert
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    expect(find.text('Already have an account? Sign In'), findsOneWidget);
  });

  testWidgets('shows validation errors for empty fields', (widgetTester) async {
    // Arrange
    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pumpAndSettle();

    // Act
    await widgetTester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await widgetTester.pumpAndSettle();

    // Assert
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Please enter a password.'), findsOneWidget);
    expect(find.text('Please confirm your password.'), findsOneWidget);
  });

  testWidgets('shows validation error for password mismatch', (widgetTester) async {
    // Arrange
    await widgetTester.pumpWidget(createWidgetUnderTest());
    await widgetTester.pumpAndSettle();

    // Act
    await widgetTester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await widgetTester.enterText(find.widgetWithText(TextFormField, 'Password'), 'Password123!');
    await widgetTester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), 'WrongPassword123!');
    await widgetTester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await widgetTester.pumpAndSettle();

    // Assert
    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('shows loading indicator when signing up', (widgetTester) async {
    // Arrange
    when(() => mockAuthProvider.isLoading).thenReturn(true);
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsNothing);
  });
}
