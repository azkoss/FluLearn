import 'package:logger/logger.dart';

///
/// 调试日志打印工具
///
class L {
  static Logger _logger = new Logger(
    // Use the default LogFilter (-> only log in debug mode)
    filter: new DebugFilter(),
    // Use the PrettyPrinter to format and print log
    printer: PrettyPrinter(
      // number of method calls to be displayed
      methodCount: 2,
      // number of method calls if stacktrace is provided
      errorMethodCount: 8,
      // width of the output
      lineLength: 120,
      // Colorful log messages
      colors: true,
      // Print an emoji for each log message
      printEmojis: false,
      // Should each log print contain a timestamp
      printTime: false,
    ),
    // Use the default LogOutput (-> send everything to console)
    output: new ConsoleOutput(),
  );

  static void d(dynamic message) {
    _logger.d(message);
  }

  static void e(dynamic message, [StackTrace stackTrace]) {
    _logger.e(message, stackTrace);
  }
}
