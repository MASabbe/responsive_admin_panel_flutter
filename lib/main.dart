import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/auth_provider.dart';
import 'package:responsive_admin_panel_flutter/features/shared/presentation/providers/team_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection.dart' as di;
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/shared/presentation/providers/theme_provider.dart';
import 'package:responsive_admin_panel_flutter/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp();

  // Initialize dependency injection
  // await di.init();

  // Initialize shared preferences
  var prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs));
}

class MyApp extends StatelessWidget {
  const MyApp(this.prefs, {super.key});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
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
            routerConfig: appRouter,
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
