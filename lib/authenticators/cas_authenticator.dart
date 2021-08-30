///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-08-28 15:25
///
part of 'authenticator.dart';

class CASAuthenticator extends Authenticator {
  factory CASAuthenticator() => _instance;

  CASAuthenticator._();

  static late final CASAuthenticator _instance = CASAuthenticator._();

  @override
  bool logonPredicate() => Boxes.containerBox.get(BoxFields.nToken) is String;

  @override
  Future<bool> login(String u, String p) async {
    final ResponseModel<TokenModel> res = await UserAPI.casLogin(u, p);
    if (res.isSucceed) {
      final String? token = res.data?.idToken;
      if (token == null) {
        return false;
      }
      User.token = token;
      Boxes.containerBox.put(BoxFields.nToken, token);
      HttpUtil.webViewCookieManager.setCookie(
        url: Uri(scheme: 'https', host: Urls.JMU_DOMAIN),
        name: 'userToken',
        value: token,
      );
    }
    return res.isSucceed;
  }

  /// We didn't figured out how would CAS act when the token was expired.
  @override
  Future<bool> reAuth([bool logoutWhenFailed = true]) {
    return Future<bool>.value(true);
  }

  @override
  Future<void> logout() async {
    await Boxes.containerBox.delete(BoxFields.nToken);
  }
}
