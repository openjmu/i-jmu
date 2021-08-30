///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/5/25 16:34
///
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info/device_info.dart';
import 'package:i_jmu/internal/boxes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../extensions/object_extension.dart';
import 'log_util.dart';
import 'other_utils.dart';

class DeviceUtil {
  const DeviceUtil._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static dynamic deviceInfo;

  static late final String deviceModel;
  static late final String deviceUuid;
  static String? devicePushToken;

  static Future<void> initDeviceInfo() async {
    await getModel();
    getUuid();
  }

  static Future<void> getModel() async {
    if (Platform.isAndroid) {
      deviceInfo = await _deviceInfoPlugin.androidInfo;
      final AndroidDeviceInfo androidInfo = deviceInfo as AndroidDeviceInfo;
      deviceModel = '${androidInfo.brand} ${androidInfo.product}';
    } else if (Platform.isIOS) {
      deviceInfo = await _deviceInfoPlugin.iosInfo;
      final IosDeviceInfo iosInfo = deviceInfo as IosDeviceInfo;
      deviceModel =
          '${iosInfo.model} ${iosInfo.utsname.machine} ${iosInfo.systemVersion}';
    } else {
      deviceModel = 'iJMU Device (${Platform.operatingSystem})';
    }
    LogUtil.d('deviceModel: $deviceModel');
  }

  static void getUuid() {
    final String? _prevUuid = Boxes.containerBox.get(BoxFields.nUUID) as String?;
    if (_prevUuid == null) {
      final String newUuid = const Uuid().v5(Uuid.NAMESPACE_OID, deviceModel);
      Boxes.containerBox.put(BoxFields.nUUID, newUuid);
      deviceUuid = newUuid;
    } else {
      deviceUuid = _prevUuid;
    }
  }

  static AndroidIntent _dialIntent(String url) {
    return AndroidIntent(
      action: 'android.intent.action.DIAL',
      data: Uri.parse(url).toString(),
    );
  }

  /// 拨打电话
  ///
  /// [tel] 电话号码。不可为空。
  static Future<void> launchTel(String tel) async {
    LogUtil.d('Launching tel: $tel');
    final String url = 'tel:$tel';
    try {
      if (Platform.isAndroid) {
        AndroidIntent? intent;
        if (await checkPermissions(<Permission>[Permission.phone])) {
          // 已授权的情况啊下，直接拉起拨号
          intent = AndroidIntent(
            action: 'android.intent.action.CALL',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            data: Uri.parse(url).toString(),
          );
        }
        (intent ?? _dialIntent(url)).launch().catchError((Object e) {
          LogUtil.e('Error when launching tel intent: $e');
        });
        return;
      }
      if (Platform.isIOS) {
        launch(url);
        return;
      }
    } catch (e) {
      if (Platform.isAndroid &&
          e is PlatformException &&
          e.message?.contains('Permission Denial') == true) {
        _dialIntent(url).launch().catchError((Object e) {
          LogUtil.e('Error when launching tel intent: $e');
        });
        return;
      }
      LogUtil.e(
        'Error when launching tel: $e, TEL - $tel',
        stackTrace: e.nullableStackTrace,
      );
    }
    throw PlatformException(
      code: '-1',
      message: 'Current platform does not support dial.',
    );
  }
}

extension LogAndroidInfoExtension on AndroidDeviceInfo {
  String get forUserAgent => '$manufacturer $model (Android/${version.sdkInt})';
}

extension LogIOSInfoExtension on IosDeviceInfo {
  String get forUserAgent => '$name (iOS/$systemVersion)';
}
