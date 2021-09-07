///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 14:46
///
import 'dart:io';

import '../authenticators/authenticator.dart';
import '../i_jmu_routes.dart';
import '../utils/http_util.dart';

import 'boxes.dart';
import 'instances.dart';

class User {
  const User._();

  static String? casToken;
  static String? ndBlowfish;
  static String? ndSession;
  static String? ndTicket;
  static String? ndUserId;

  static void recoverUserInfo() {
    casToken = Boxes.containerBox.get(BoxFields.nToken) as String?;
    ndBlowfish = Boxes.containerBox.get(BoxFields.nBlowfish) as String?;
    ndSession = Boxes.containerBox.get(BoxFields.nSession) as String?;
    ndTicket = Boxes.containerBox.get(BoxFields.nTicket) as String?;
    ndUserId = Boxes.containerBox.get(BoxFields.nUid) as String?;
    if (casToken != null) {
      HttpUtil.webViewCookieManager.setCookie(
        url: Uri(scheme: 'https', host: 'jmu.edu.cn'),
        name: 'userToken',
        value: casToken!,
      );
    }
  }

  static void setUP(String u, String p) {
    Boxes.containerBox.put(BoxFields.nU, u);
    Boxes.containerBox.put(BoxFields.nP, p);
  }

  static List<Cookie> buildNDCookies() => <Cookie>[
        if (User.ndSession != null)
          Cookie('PHPSESSID', User.ndSession!)..httpOnly = false,
        if (User.ndSession != null)
          Cookie('OAPSID', User.ndSession!)..httpOnly = false,
      ];

  static void logout() {
    navigator.pushNamedAndRemoveUntil(Routes.jmuLoginPage.name, (_) => false);
    Future<void>.delayed(
      const Duration(milliseconds: 300),
      () {
        Authenticator.logoutAll();
        Boxes.containerBox.clear();
        HttpUtil.webViewCookieManager.deleteAllCookies();
      },
    );
  }
}
