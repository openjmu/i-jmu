///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 11/27/20 3:09 PM
///
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  NavigatorState get navigator => Navigator.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ButtonThemeData get buttonTheme => theme.buttonTheme;

  IconThemeData get iconTheme => IconTheme.of(this);

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  double get bottomViewInsets => mediaQuery.viewInsets.bottom;

  Color get surfaceColor => theme.colorScheme.surface;

  Brightness get brightness => theme.brightness;
}
