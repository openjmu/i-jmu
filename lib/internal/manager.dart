///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 14:46
///
import '../i_jmu_routes.dart';
import '../utils/http_util.dart';

import 'boxes.dart';
import 'instances.dart';

class User {
  const User._();

  static String? token;
  static String? blowfish;
  static String? session;
  static String? ticket;

  static void recoverToken() {
    token = Boxes.containerBox.get(BoxFields.nToken) as String?;
    if (token != null) {
      HttpUtil.webViewCookieManager.setCookie(
        url: Uri(scheme: 'https', host: 'jmu.edu.cn'),
        name: 'userToken',
        value: token!,
      );
    }
  }

  static void setUP(String u, String p) {
    Boxes.containerBox.put(BoxFields.nU, u);
    Boxes.containerBox.put(BoxFields.nP, p);
  }

  static void logout() {
    navigator.pushNamedAndRemoveUntil(Routes.jmuLoginPage.name, (_) => false);
    Future<void>.delayed(
      const Duration(milliseconds: 300),
      Boxes.containerBox.clear,
    );
  }
}
