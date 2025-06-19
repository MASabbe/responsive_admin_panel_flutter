class AppConstants {
  static const String appName = 'Admin Panel';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://apimock.lazycatlabs.com/';
  
  // Shared Preferences Keys
  static const String themeKey = 'theme_mode';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Pagination
  static const int defaultPageSize = 10;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';
}
