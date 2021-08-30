///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-08-28 11:38
///
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../extensions/object_extension.dart';
import '../internal/api.dart';
import '../internal/boxes.dart';
import '../internal/urls.dart';
import '../internal/user.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/device_util.dart';
import '../utils/http_util.dart';
import '../utils/log_util.dart';

part 'cas_authenticator.dart';

part 'nd_authenticator.dart';

abstract class Authenticator {
  static final Set<Authenticator> _authenticators = <Authenticator>{};

  static bool get hasLogin {
    if (_authenticators.isEmpty) {
      throw StateError('No authenticators have been registered.');
    }
    return _authenticators.every((Authenticator au) => au.logonPredicate());
  }

  static Future<List<bool>> loginAll(String u, String p) => Future.wait(
        _authenticators.map((Authenticator au) => au.login(u, p)),
      );

  static Future<List<bool>> reAuthAll([bool logoutWhenFailed = true]) =>
      Future.wait(
        _authenticators.map((Authenticator au) => au.reAuth(logoutWhenFailed)),
      );

  static Future<void> logoutAll() => Future.wait(
        _authenticators.map((Authenticator au) => au.logout()),
      );

  static void add(Authenticator instance) => _authenticators.add(instance);

  static void clear(Authenticator instance) => _authenticators.clear();

  static void remove(Authenticator instance) =>
      _authenticators.remove(instance);

  static void addAll(Iterable<Authenticator> instances) =>
      _authenticators.addAll(instances);

  bool logonPredicate();

  Future<bool> login(String u, String p);

  Future<bool> reAuth([bool logoutWhenFailed = true]);

  Future<void> logout();
}
