import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/pages/sign_in_page.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/pages/sign_up_page.dart';
import 'package:responsive_admin_panel_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/pages/all_users_page.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/pages/edit_profile_page.dart';
import 'package:responsive_admin_panel_flutter/features/user/presentation/pages/profile_page.dart';
import 'package:responsive_admin_panel_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:responsive_admin_panel_flutter/routes/route_names.dart';

class AppRouter {
  static final Logger _logger = Logger();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      initialLocation: RouteNames.splash,
      routes: [
        GoRoute(
          path: RouteNames.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouteNames.login,
          name: RouteNames.login,
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: RouteNames.signup,
          name: RouteNames.signup,
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: RouteNames.dashboard,
          name: RouteNames.dashboard,
          builder: (context, state) => const DashboardPage(),
          routes: [
            GoRoute(
              path: 'users',
              name: RouteNames.users,
              builder: (context, state) => const AllUsersPage(),
            ),
            GoRoute(
              path: 'profile',
              name: RouteNames.profile,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: RouteNames.editProfile,
                  builder: (context, state) => const EditProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final bool isAuthenticated = authProvider.isAuthenticated;
        final bool isLoading = authProvider.isLoading;
        final String location = state.matchedLocation;

        _logger.d('Redirect check: location=$location, isAuthenticated=$isAuthenticated, isLoading=$isLoading');

        if (isLoading) {
          return RouteNames.splash;
        }

        final bool onLoginPage = location == RouteNames.login;
        final bool onSignupPage = location == RouteNames.signup;
        final bool onSplashPage = location == RouteNames.splash;

        // If the user is not authenticated, redirect to the login page,
        // unless they are already on the login page or signup page.
        if (!isAuthenticated) {
          if (onLoginPage || onSignupPage) {
            return null;
          }
          return RouteNames.login;
        }

        // If the user is authenticated and on the login or splash page or signup page,
        // redirect to the dashboard.
        if (isAuthenticated && (onLoginPage || onSplashPage || onSignupPage)) {
          return RouteNames.dashboard;
        }

        return null;
      },
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.error}'),
        ),
      ),
    );
  }
}
