///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/4/29 13:49
///
import 'package:dio/dio.dart' show DioError;

extension ObjectExtension on Object {}

extension NullableObjectExtension on Object? {
  String get errorMessage {
    final Object? object = this;
    if (object is DioError) {
      return object.message;
    }
    if (object is AssertionError) {
      return object.message?.toString() ?? 'unknown assertion';
    }
    if (object is ArgumentError) {
      return object.message?.toString() ?? 'unknown argument';
    }
    if (object is StateError) {
      return object.message;
    }
    return Error.safeToString(this);
  }

  StackTrace? get nullableStackTrace {
    if (this is Error) {
      return (this as Error).stackTrace;
    }
    return null;
  }
}
