import 'package:logger/logger.dart';

class LoggerService extends Logger {
  void logError(String message, {String? errorTitle}) =>
      e(message, error: errorTitle);

  void logWarning(String message) => w(message);
  void logInfo(String message) => i(message);

  void logFatalError(
    String message, {
    required String error,
    required StackTrace stackTrace,
  }) =>
      f(
        message,
        error: error,
        stackTrace: stackTrace,
      );
}