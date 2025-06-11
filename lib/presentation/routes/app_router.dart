import 'package:flutter/material.dart';
import 'package:responsive_admin_panel_flutter/presentation/pages/dashboard_page.dart';
import 'package:responsive_admin_panel_flutter/presentation/pages/sign_in_page.dart';
import 'package:responsive_admin_panel_flutter/presentation/routes/route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _buildRoute(settings, const SplashPage());
      case RouteNames.login:
        return _buildRoute(settings, const SignInPage());
      case RouteNames.dashboard:
        return _buildRoute(settings, const DashboardPage());
      case RouteNames.teams:
        return _buildRoute(settings, const DashboardPage());
      // Add more routes here
      default:
        return _buildRoute(
          settings,
          Scaffold(
            body: Center(
              child: Text('No route defined for $settings'),
            ),
          ),
        );
    }
  }

  static PageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }
}

// Placeholder widget classes - Replace with actual page widgets
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}
