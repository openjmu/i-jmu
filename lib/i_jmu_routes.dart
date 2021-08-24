// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************

import 'package:flutter/material.dart';

const List<String> routeNames = <String>[
  'jmu://login-page',
  'jmu://main-page',
  'jmu://splash-page',
  'jmu://web-view',
];

class Routes {
  const Routes._();

  /// '登录页'
  ///
  /// [name] : 'jmu://login-page'
  ///
  /// [routeName] : '登录页'
  ///
  /// [constructors] :
  ///
  /// LoginPage : [Key? key]
  static const _JmuLoginPage jmuLoginPage = _JmuLoginPage();

  /// '首页'
  ///
  /// [name] : 'jmu://main-page'
  ///
  /// [routeName] : '首页'
  ///
  /// [constructors] :
  ///
  /// MainPage : [Key? key]
  static const _JmuMainPage jmuMainPage = _JmuMainPage();

  /// '闪屏页'
  ///
  /// [name] : 'jmu://splash-page'
  ///
  /// [routeName] : '闪屏页'
  ///
  /// [constructors] :
  ///
  /// SplashPage : [Key? key]
  static const _JmuSplashPage jmuSplashPage = _JmuSplashPage();

  /// '网页浏览'
  ///
  /// [name] : 'jmu://web-view'
  ///
  /// [routeName] : '网页浏览'
  ///
  /// [constructors] :
  ///
  /// InAppWebViewPage : [Key? key, String(required) url, String? title, bool withCookie, bool withAction, bool withNavigationControls, bool withScaffold, bool keepAlive]
  static const _JmuWebView jmuWebView = _JmuWebView();
}

class _JmuLoginPage {
  const _JmuLoginPage();

  String get name => 'jmu://login-page';

  Map<String, dynamic> d({Key? key}) => <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _JmuMainPage {
  const _JmuMainPage();

  String get name => 'jmu://main-page';

  Map<String, dynamic> d({Key? key}) => <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _JmuSplashPage {
  const _JmuSplashPage();

  String get name => 'jmu://splash-page';

  Map<String, dynamic> d({Key? key}) => <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _JmuWebView {
  const _JmuWebView();

  String get name => 'jmu://web-view';

  Map<String, dynamic> d(
          {Key? key,
          required String url,
          String? title = '网页链接',
          bool withCookie = true,
          bool withAction = true,
          bool withNavigationControls = true,
          bool withScaffold = true,
          bool keepAlive = false}) =>
      <String, dynamic>{
        'key': key,
        'url': url,
        'title': title,
        'withCookie': withCookie,
        'withAction': withAction,
        'withNavigationControls': withNavigationControls,
        'withScaffold': withScaffold,
        'keepAlive': keepAlive,
      };

  @override
  String toString() => name;
}
