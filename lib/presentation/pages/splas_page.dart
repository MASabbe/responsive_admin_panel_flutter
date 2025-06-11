import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/presentation/routes/route_names.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Pastikan sudah initialize authProvider
    await authProvider.initialize();
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, RouteNames.dashboard);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan logo atau animasi sesuai kebutuhan
            Icon(Icons.admin_panel_settings, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Responsive Admin Panel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
