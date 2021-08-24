///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/4/25 18:34
///
import 'package:flutter/widgets.dart';
import 'package:i_jmu/utils/toast_util.dart';

/// 双击返回桌面
///
/// 请仅在栈顶页面使用，并包在最外层
class DoubleBackExitWrapper extends StatelessWidget {
  const DoubleBackExitWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: doubleBackExit, child: child);
  }
}

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
