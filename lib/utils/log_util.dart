///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 11/26/20 8:23 PM
///
import 'dart:developer' as _dev;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../constants/constants.dart' show currentTime;

typedef LogFunction = void Function(
  Object message,
  String tag,
  StackTrace stackTrace, {
  bool? isError,
  Level? level,
});

class LogUtil {
  const LogUtil._();

  static const String _TAG = 'LOG';

  static const bool isLogEnabled = bool.fromEnvironment(
    'expressEnableLog',
    defaultValue: true,
  );

  static const bool isNativeLogEnabled = bool.fromEnvironment(
    'expressEnableNativeLog',
    defaultValue: false,
  );

  static final ObserverList<LogFunction> _listeners =
      ObserverList<LogFunction>();

  static void addListener(LogFunction listener) {
    _listeners.add(listener);
  }

  static void removeListener(LogFunction listener) {
    _listeners.remove(listener);
  }

  static void i(
    Object? message, {
    String tag = _TAG,
    StackTrace? stackTrace,
  }) {
    _printLog(
      message,
      '$tag ❕',
      stackTrace,
      level: Level.CONFIG,
    );
  }

  static void d(
    Object? message, {
    String tag = _TAG,
    StackTrace? stackTrace,
  }) {
    _printLog(
      message,
      '$tag 📣',
      stackTrace,
      level: Level.INFO,
    );
  }

  static void w(
    Object? message, {
    String tag = _TAG,
    StackTrace? stackTrace,
  }) {
    _printLog(
      message,
      '$tag ⚠️',
      stackTrace,
      level: Level.WARNING,
    );
  }

  static void e(
    Object? message, {
    String tag = _TAG,
    StackTrace? stackTrace,
  }) {
    _printLog(
      message,
      '$tag ❌',
      stackTrace,
      isError: true,
      level: Level.SEVERE,
    );
  }

  static void json(
    Object? message, {
    String tag = _TAG,
    StackTrace? stackTrace,
  }) {
    _printLog(message, '$tag 💠', stackTrace);
  }

  static void _printLog(
    Object? message,
    String tag,
    StackTrace? stackTrace, {
    bool isError = false,
    Level level = Level.ALL,
  }) {
    final DateTime _time = currentTime;
    final String _timeString = currentTime.toIso8601String();
    if (isLogEnabled) {
      if (isError) {
        _dev.log(
          '$_timeString - An error occurred.',
          time: _time,
          name: tag,
          level: level.value,
          error: message,
          stackTrace: stackTrace,
        );
        if (isNativeLogEnabled) {
          debugPrint(
            '[$tag] $_timeString - An error occurred.\n$message',
          );
        }
      } else {
        _dev.log(
          '$_timeString - $message',
          time: _time,
          name: tag,
          level: level.value,
          stackTrace: stackTrace,
        );
        if (isNativeLogEnabled) {
          debugPrint('[$tag] $_timeString - $message');
        }
      }
    }
  }
}
