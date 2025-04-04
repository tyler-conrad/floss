import 'dart:developer' as dev;

import 'package:flutter/foundation.dart' as f;

import 'package:logger/logger.dart' as logger;

/// A class that represents console output for logging.
///
/// This class extends the [logger.LogOutput] class and overrides the [output]
/// method. The [output] method takes an [logger.OutputEvent] object as a
/// parameter and outputs each line of the event to the console using the
/// [f.debugPrint] and [dev.log] functions.
class _ConsoleOutput extends logger.LogOutput {
  @override
  void output(logger.OutputEvent event) {
    for (var line in event.lines) {
      f.debugPrint(line);
      dev.log(line);
    }
  }
}

/// Initializes a logger with the specified configuration.
///
/// The logger is initialized with a `printer` that formats log messages in a
/// pretty way, with no boxing by default. The `output` specifies where the log
/// messages should be written to, in this case, it uses a custom
/// [_ConsoleOutput] class. The `level` sets the minimum log level that should
/// be logged, in this case, it is set to [logger.Level.trace].
final _log = logger.Logger(
  printer: logger.PrettyPrinter(noBoxingByDefault: true),
  output: _ConsoleOutput(),
  level: logger.Level.trace,
);

/// A private class representing a logger.
///
/// This class provides methods for logging messages at different levels:
/// - `t()`: Trace level
/// - `d()`: Debug level
/// - `i()`: Info level
/// - `w()`: Warning level
/// - `e()`: Error level
/// - `f()`: Fatal level
///
/// Each method accepts a `message` parameter which represents the log message,
/// and optional parameters for `time`, `error`, and `stackTrace`.
/// The log message is then passed to the `_logAtLevel` method along with the
/// corresponding log level.
///
/// Example usage:
/// ```dart
/// _Logger logger = _Logger();
/// logger.i('This is an info message');
/// logger.e('An error occurred', error: exception, stackTrace: stackTrace);
/// ```
class _Logger {
  /// Logs a message at the specified [level].
  ///
  /// The [message] parameter represents the message to be logged.
  /// The [time] parameter represents the timestamp of the log entry.
  /// The [error] parameter represents an optional error object associated with the log entry.
  /// The [stackTrace] parameter represents an optional stack trace associated with the log entry.
  void _logAtLevel(
    logger.Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => _log.log(
    level,
    message,
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Logs a message at the trace level.
  void t(
    dynamic message,
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  ) => _logAtLevel(
    logger.Level.trace,
    message,
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Logs a message at the debug level.
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => _logAtLevel(
    logger.Level.debug,
    message,
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Logs a message at the info level.
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => _logAtLevel(
    logger.Level.info,
    message,
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Logs a message at the warning level.
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => _logAtLevel(
    logger.Level.warning,
    message,
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Logs a message at the error level.
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => _logAtLevel(
    logger.Level.error,
    message,
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Logs a message at the fatal level.
  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => _logAtLevel(
    logger.Level.fatal,
    message,
    time: time,
    error: error,
    stackTrace: stackTrace,
  );
}

/// A global instance of the [_Logger] class.
final l = _Logger();
