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
  }

  static void recoverToken() {
    _token = Boxes.settingsBox.get(BoxFields.nToken) as String?;
  }

  static Future<ResponseModel<TokenModel>> login(String u, String p) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: API.login,
      queryParameters: <String, String>{
        'appId': 'com.openjmu.iJMU',
        // 'clientId': 'eda0f8479cdcd48ad60c3405915e6c75',
        'deviceId': 'WkkJ+qqKKWMDAHn4sSFxRjok',
        'username': u,
        'password': p,
      },
    );
  }
}
