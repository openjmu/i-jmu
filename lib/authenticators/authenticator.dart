///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-08-28 11:38
///
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../internal/api.dart';
import '../internal/boxes.dart';
import '../internal/manager.dart';
import '../internal/urls.dart';
import '../models/data_model.dart';
import '../models/response_model.dart';
import '../utils/device_util.dart';
import '../utils/http_util.dart';
import '../utils/log_util.dart';

part 'cas_authenticator.dart';

part 'nd_authenticator.dart';

abstract class Authenticator {
  static final Set<Authenticator> authenticators = <Authenticator>{};

  static bool get hasLogin {
    if (authenticators.isEmpty) {
      throw StateError('No authenticators have been registered.');
    }
    return authenticators.every((Authenticator au) => au.logonPredicate());
  }

  static Future<List<bool>> loginAll(String u, String p) => Future.wait(
        authenticators.map((Authenticator au) => au.login(u, p)),
      );

  bool logonPredicate();

  Future<bool> login(String u, String p);

  Future<bool> reAuth([bool logoutWhenFailed = true]);

  Future<void> logout();
}
