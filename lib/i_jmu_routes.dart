// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************

import 'package:flutter/material.dart';

const List<String> routeNames = <String>[
  'jmu://login-page',
  'jmu://main-page',
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