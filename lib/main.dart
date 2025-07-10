import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_admin_panel_flutter/core/constants/app_constants.dart';
import 'package:responsive_admin_panel_flutter/core/theme/app_theme.dart';
import 'package:responsive_admin_panel_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/team_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/theme_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/providers/drawer_provider.dart';
import 'package:responsive_admin_panel_flutter/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_admin_panel_flutter/routes/app_router.dart';
import 'package:responsive_admin_panel_flutter/injection.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_admin_panel_flutter/core/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    log.e('FlutterError caught', error: details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
    // You can also send error details to an external logging service here
    // Example: Sentry.captureException(details.exception, stackTrace: details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log.e('PlatformDispatcher error caught', error: error, stackTrace: stack);
    // You can also send error details to an external logging service here
    // Example: Sentry.captureException(error, stackTrace: stack);
    return true;
  };

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  await di.init();

  // Create router
  final router = AppRouter.createRouter(di.sl<AuthProvider>());

  // Initialize shared preferences
  var prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs, router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.prefs, required this.router, super.key});

  final SharedPreferences prefs;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        // Add other providers here
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
            ],
          );
        },
      ),
    );
  }
}
