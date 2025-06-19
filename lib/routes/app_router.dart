import 'package:go_router/go_router.dart';
import 'package:responsive_admin_panel_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/pages/sign_in_page.dart';
import 'package:responsive_admin_panel_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:responsive_admin_panel_flutter/routes/route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: RouteNames.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.login,
      name: 'login',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: RouteNames.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
