///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 11:00
///
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'log_util.dart';
import 'toast_util.dart';

/// Last time stamp when user trying to exit app.
/// 用户最后一次触发退出应用的时间戳
int _lastWantToPop = 0;

/// Method that check if user triggered back twice quickly.
/// 检测用户是否快读点击了两次返回，用于双击返回桌面功能。
Future<bool> doubleBackExit() async {
  final int now = DateTime.now().millisecondsSinceEpoch;
  if (now - _lastWantToPop > 800) {
    showToast('再按一次退出应用');
    _lastWantToPop = DateTime.now().millisecondsSinceEpoch;
    return false;
  } else {
    dismissAllToast();
    return true;
  }
}

/// Just do nothing. :)
void doNothing() {}

/// Check permissions and only return whether they succeed or not.
Future<bool> checkPermissions(List<Permission> permissions) async {
  try {
    final Map<Permission, PermissionStatus> status =
    await permissions.request();
    return !status.values.any(
          (PermissionStatus p) => p != PermissionStatus.granted,
    );
  } catch (e) {
    LogUtil.e('Error when requesting permission: $e');
    return false;
  }
}

/// Iterate element and its children to request rebuild.
void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}
