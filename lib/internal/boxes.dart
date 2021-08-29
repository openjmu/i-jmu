///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 15:22
///
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/data_model.dart';

class Boxes {
  const Boxes._();

  static late final Box<DataModel?> dataCachesBox;
  static late final Box<Object?> settingsBox;

  static Future<void> openBoxes() async {
    Hive
      ..registerAdapter(SystemConfigAdapter())
      ..registerAdapter(SystemConfigECardAdapter())
      ..registerAdapter(BannerConfigAdapter())
      ..registerAdapter(BannerModelAdapter())
      ..registerAdapter(ServiceModelAdapter());
    await Future.wait(
      <Future<void>>[
        (() async =>
            dataCachesBox = await Hive.openBox(_BoxNames._dataCaches))(),
        (() async =>
            settingsBox = await Hive.openBox(_BoxNames._settings))(),
      ],
      eagerError: true,
    );
  }
}

class _BoxNames {
  const _BoxNames._();

  static const String _prefix = 'i-jmu';
  static const String _dataCaches = '$_prefix-data-caches';
  static const String _settings = '$_prefix-settings';
}

class BoxTypeIds {
  const BoxTypeIds._();

  static const int systemConfig = 0;
  static const int systemConfigECard = 1;
  static const int bannerConfig = 2;
  static const int bannerModel = 3;
  static const int serviceModel = 4;
}

class BoxFields {
  const BoxFields._();

  static const String nU = 'u';
  static const String nP = 'p';
  static const String nToken = 'token';
  static const String nTicket = 'ticket';
  static const String nSession = 'session';
  static const String nBlowfish = 'blowfish';
  static const String nUUID = 'uuid';

  static const String nMainSystemConfig = 'main-system-config';
  static const String nMainBannerConfig = 'main-banner-config';
}
