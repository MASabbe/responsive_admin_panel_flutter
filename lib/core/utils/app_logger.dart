import 'package:logger/logger.dart';

/// A global logger instance for the application.
///
/// Provides different log levels:
/// - `log.v('Verbose log')`
/// - `log.d('Debug log')`
/// - `log.i('Info log')`
/// - `log.w('Warning log')`
/// - `log.e('Error log', error: 'Some error', stackTrace: StackTrace.current)`
/// - `log.wtf('What a terrible failure log')`
final log = Logger(
  printer: PrettyPrinter(
    methodCount: 1,       // Number of method calls to be displayed
    errorMethodCount: 8,  // Number of method calls if stacktrace is provided
    lineLength: 120,      // Width of the output
    colors: true,         // Colorful log messages
    printEmojis: true,    // Print an emoji for each log message
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Should each log print contain a timestamp
  ),
);
