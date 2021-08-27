///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 14:46
///
part of 'api.dart';

class UserAPI {
  const UserAPI._();

  static bool get isLogon => _token != null;

  static String? get token => _token;
  static String? _token;

  static set token(String? value) {
    _token = value;
    if (value == null) {
      Boxes.settingsBox.delete(BoxFields.nToken);
      return;
    }
    Boxes.settingsBox.put(BoxFields.nToken, value);
    HttpUtil.webViewCookieManager.setCookie(
      url: Uri(scheme: 'https', host: 'jmu.edu.cn'),
      name: 'userToken',
      value: value,
    );
  }

  static void recoverToken() {
    _token = Boxes.settingsBox.get(BoxFields.nToken) as String?;
    if (_token != null) {
      HttpUtil.webViewCookieManager.setCookie(
        url: Uri(scheme: 'https', host: 'jmu.edu.cn'),
        name: 'userToken',
        value: _token!,
      );
    }
  }

  static Future<ResponseModel<TokenModel>> login(String u, String p) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: API.login,
      queryParameters: <String, String>{
        'appId': 'com.openjmu.iJMU',
        'clientId': md5.convert(utf8.encode(DeviceUtil.deviceUuid)).toString(),
        'deviceId': base64.encode(utf8.encode(DeviceUtil.deviceModel)),
        'username': u,
        'password': p,
      },
    );
  }

  static void setUP(String u, String p) {
    Boxes.settingsBox.put(BoxFields.nU, u);
    Boxes.settingsBox.put(BoxFields.nP, p);
  }

  static void logout() {
    navigator.pushNamedAndRemoveUntil(Routes.jmuLoginPage.name, (_) => false);
    Future<void>.delayed(
      const Duration(milliseconds: 300),
      Boxes.settingsBox.clear,
    );
  }
}
