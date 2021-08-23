///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/9/17 14:47
///
import 'package:flutter/widgets.dart' show Characters;

import 'date_time_extension.dart';

extension StringExtension on String {
  String get notBreak => Characters(this).join('\u{200B}');

  String get trimmed => trim();

  String get shield => replaceRange(3, length - 4, '****');

  int toInt() => int.parse(this);

  double toDouble() => double.parse(this);
}

extension NullableStringExtension on String? {
  String get timeText => withDateTimeFormat();

  String withDateTimeFormat([String format = 'yyyy-MM-dd HH:mm:ss']) {
    if (this == null) {
      return '';
    }
    return DateTime.parse(this!).withDateTimeFormat(format);
  }

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  int? toIntOrNull() => this == null ? null : int.tryParse(this!);

  double? toDoubleOrNull() => this == null ? null : double.tryParse(this!);
}
