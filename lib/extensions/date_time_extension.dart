///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 1/6/21 3:57 PM
///
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime get startOfTheDay => DateTime(year, month, day);

  DateTime get endOfTheDay => DateTime(year, month, day, 23, 59, 59);
}

extension NullableDateTimeExtension on DateTime? {
  String get timeText => withDateTimeFormat();

  String withDateTimeFormat([String format = 'yyyy-MM-dd HH:mm:ss']) {
    if (this == null) {
      return '';
    }
    return DateFormat(format).format(this!);
  }
}
