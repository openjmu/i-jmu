///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 10:57
///
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const JsonEncoder GlobalJsonEncoder = JsonEncoder.withIndent('  ');

DateTime get currentTime => DateTime.now();

int get currentTimeStamp => currentTime.millisecondsSinceEpoch;

Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates {
  return <LocalizationsDelegate<dynamic>>[
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}

Iterable<Locale> get supportedLocales {
  return <Locale>[
    const Locale.fromSubtags(languageCode: 'zh'),
    const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans',
    ),
    const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
    ),
    const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans',
      countryCode: 'CN',
    ),
    const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
      countryCode: 'TW',
    ),
    const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
      countryCode: 'HK',
    ),
  ];
}

/// Empty counter builder for [TextField].
Widget? emptyCounterBuilder(
  BuildContext _, {
  required int currentLength,
  int? maxLength,
  required bool isFocused,
}) =>
    null;
