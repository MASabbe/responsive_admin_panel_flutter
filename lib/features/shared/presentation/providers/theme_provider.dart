import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeMode _themeMode;
  final SharedPreferences _prefs;
  bool _isDarkMode = false;

  ThemeProvider(this._prefs) {
    _loadTheme();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  // Load theme preference from shared preferences
  Future<void> _loadTheme() async {
    try {
      _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
      _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
      _themeMode = ThemeMode.system;
    }
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    try {
      await _prefs.setBool('isDarkMode', _isDarkMode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Get appropriate theme text color based on brightness
  Color getTextThemeColor(BuildContext context) {
    return _isDarkMode ? Colors.white : Colors.black87;
  }

  // Get appropriate card color based on theme
  Color getCardColor() {
    return _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  // Get appropriate scaffold background color
  Color getScaffoldBackgroundColor() {
    return _isDarkMode ? const Color(0xFF121212) : Colors.grey[50]!;
  }

  // Get appropriate divider color
  Color getDividerColor() {
    return _isDarkMode ? Colors.white24 : Colors.grey[300]!;
  }
}
