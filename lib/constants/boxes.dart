///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 15:22
///
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  const Boxes._();

  static late final Box<dynamic> settingsBox;

  static Future<void> openBoxes() async {
    await Future.wait(
      <Future<void>>[
        (() async =>
            settingsBox = await Hive.openBox<dynamic>(_BoxNames._settings))(),
      ],
      eagerError: true,
    );
  }
}

class _BoxNames {
  const _BoxNames._();

  static const String _prefix = 'i-jmu';
  static const String _settings = '$_prefix-settings';
}

class BoxFields {
  const BoxFields._();

  static const String nToken = 'token';
}
