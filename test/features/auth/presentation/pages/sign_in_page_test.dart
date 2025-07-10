import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/pages/sign_in_page.dart';
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
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SignInPage()),
        GoRoute(
          path: RouteNames.dashboard,
          builder: (context, state) => const Scaffold(body: Text('Dashboard')),
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

  testWidgets('SignInPage should render initial widgets correctly', (widgetTester) async {
    // Arrange
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Enter your email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Enter your password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);
  });

  testWidgets('shows validation errors for empty fields', (widgetTester) async {
    // Arrange
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Act
    await widgetTester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await widgetTester.pumpAndSettle();

    // Assert
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('shows loading indicator when signing in', (widgetTester) async {
    // Arrange
    when(() => mockAuthProvider.isLoading).thenReturn(true);
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsNothing);
  });

  testWidgets('calls signIn on AuthProvider when form is valid and button is tapped', (widgetTester) async {
    // Arrange
    when(() => mockAuthProvider.signIn(any(), any())).thenAnswer((_) async => true);
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Act
    await widgetTester.enterText(find.widgetWithText(TextFormField, 'Enter your email'), 'test@example.com');
    await widgetTester.enterText(find.widgetWithText(TextFormField, 'Enter your password'), 'password');
    await widgetTester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await widgetTester.pumpAndSettle(); // pumpAndSettle to allow navigation to complete

    // Assert
    verify(() => mockAuthProvider.signIn('test@example.com', 'password')).called(1);
    expect(find.text('Dashboard'), findsOneWidget); // Verify navigation to dashboard
  });
}
