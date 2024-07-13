import 'dart:developer' as dev;

import 'package:flutter/material.dart' as m;

import 'package:logger/logger.dart' as logger;

class _ConsoleOutput extends logger.LogOutput {
  @override
  void output(logger.OutputEvent event) {
    for (var line in event.lines) {
      m.debugPrint(line);
      dev.log(line);
    }
  }
}

final _log = logger.Logger(
  printer: logger.PrettyPrinter(
    printTime: true,
    noBoxingByDefault: true,
  ),
  output: _ConsoleOutput(),
  level: logger.Level.trace,
);

class _Logger {
  void _logAtLevel(
    logger.Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log.log(
        level,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  void t(
    dynamic message,
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  ) =>
      _logAtLevel(
        logger.Level.trace,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logAtLevel(
        logger.Level.debug,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logAtLevel(
        logger.Level.info,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logAtLevel(
        logger.Level.warning,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logAtLevel(
        logger.Level.error,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logAtLevel(
        logger.Level.fatal,
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );
}

final l = _Logger();
