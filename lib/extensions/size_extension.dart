///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/9/7 16:56
///
// import 'package:flutter_screenutil/flutter_screenutil.dart' hide SizeExtension;

import '../internal/screens.dart';

/// dp => px
extension DP2PXExtension on double {
  int get px => (this * Screens.scale).toInt();
}

/// px => dp
extension PX2DPExtension on int {
  double get dp => this / Screens.scale;
}

/// ScreenUtil 的封装，用于快速等比例缩放
///
/// 通过使用扩展方法，我们可以直接将适配应用到数值上。
/// 例如：`10.fw`，代表以 10 逻辑宽度像素对内容做适配。
// extension FixedSizeDoubleExtension on num {
//   /// [ScreenUtil.setWidth]
//   double get fw => ScreenUtil().setWidth(this).toDouble();
//
//   /// [ScreenUtil.setHeight]
//   double get fh => ScreenUtil().setHeight(this).toDouble();
//
//   /// [ScreenUtil.setSp]
//   double get fsp => ScreenUtil().setSp(this).toDouble();
//
//   /// [ScreenUtil.setSp]
//   double get fssp =>
//       ScreenUtil().setSp(this, allowFontScalingSelf: true).toDouble();
//
//   /// [ScreenUtil.setSp]
//   double get fnsp =>
//       ScreenUtil().setSp(this, allowFontScalingSelf: false).toDouble();
//
//   /// 屏幕宽度的倍数
//   /// Multiple of screen width.
//   double get fwp => (ScreenUtil.screenWidth * this).toDouble();
//
//   /// 屏幕高度的倍数
//   /// Multiple of screen height.
//   double get fhp => (ScreenUtil.screenHeight * this).toDouble();
// }
