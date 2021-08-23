///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/27 16:47
///
import 'dart:async';

import 'package:intl/intl.dart' show DateFormat;
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/constants.dart';

import 'log_util.dart';

class PackageUtil {
  const PackageUtil._();

  static const String _currentBuildTime = String.fromEnvironment(
    'expressBuildTime',
  );

  static String get currentBuildTime {
    if (_currentBuildTime.isNotEmpty) {
      return _currentBuildTime;
    }
    return 'DEBUG_${DateFormat('yyyyMMddhhmm').format(currentTime)}';
  }

  static late final PackageInfo packageInfo;
  static late final String currentVersion;
  static late final int? currentBuildNumber;

  /// x.y.z+a
  static String get versionAndBuildString =>
      '$currentVersion+$currentBuildNumber';

  static Future<void> initInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
    currentBuildNumber = int.tryParse(packageInfo.buildNumber);
    LogUtil.d(GlobalJsonEncoder.convert(<String, dynamic>{
      'packageInfo': packageInfo.toJson(),
      'currentVersion': currentVersion,
      'currentBuildNumber': currentBuildNumber,
    }));
  }
}

extension PackageInfoJsonExtension on PackageInfo {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }
}
