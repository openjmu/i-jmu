///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-08-28 15:57
///
part of 'authenticator.dart';

class NDAuthenticator extends Authenticator {
  factory NDAuthenticator() => _instance;

  NDAuthenticator._();

  static late final NDAuthenticator _instance = NDAuthenticator._();

  @override
  bool logonPredicate() =>
      Boxes.settingsBox.get(BoxFields.nTicket) is String ||
      Boxes.settingsBox.get(BoxFields.nSession) is String ||
      Boxes.settingsBox.get(BoxFields.nBlowfish) is String;

  @override
  Future<bool> login(String u, String p) async {
    final String blowfish = const Uuid().v4();
    final Map<String, dynamic> params = _loginParams(
      blowfish: blowfish,
      username: u,
      password: p,
    );
    try {
      final Map<String, dynamic> res = await UserAPI.ndLogin(params);
      User.blowfish = blowfish;
      Boxes.settingsBox.put(BoxFields.nBlowfish, blowfish);
      User.session = res['sid'] as String;
      Boxes.settingsBox.put(BoxFields.nSession, res['sid'] as String);
      User.ticket = res['ticket'] as String;
      Boxes.settingsBox.put(BoxFields.nTicket, res['ticket'] as String);
      return true;
    } catch (e) {
      LogUtil.e('Error when login with NDAuthenticator: $e');
      return false;
    }
  }

  @override
  Future<bool> reAuth([bool logoutWhenFailed = true]) async {
    if (Boxes.settingsBox.get(BoxFields.nBlowfish) is! String ||
        Boxes.settingsBox.get(BoxFields.nTicket) is! String) {
      return false;
    }
    final Map<String, dynamic> params = _loginParams(
      blowfish: Boxes.settingsBox.get(BoxFields.nBlowfish) as String,
      ticket: Boxes.settingsBox.get(BoxFields.nTicket) as String,
    );
    try {
      final Map<String, dynamic> res = await UserAPI.ndTicket(params);
      User.session = res['sid'] as String;
      Boxes.settingsBox.put(BoxFields.nSession, res['sid'] as String);
      return true;
    } catch (e) {
      LogUtil.e('Error when fetching ticket with NDAuthenticator: $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    Boxes.settingsBox.delete(BoxFields.nBlowfish);
    Boxes.settingsBox.delete(BoxFields.nTicket);
    Boxes.settingsBox.delete(BoxFields.nSession);
  }

  Map<String, dynamic> _loginParams({
    required String blowfish,
    String? username,
    String? password,
    String? ticket,
  }) {
    return <String, dynamic>{
      'appid': _appId,
      'blowfish': blowfish,
      if (ticket != null) 'ticket': ticket,
      if (username != null) 'account': username,
      if (password != null)
        'password': '${sha1.convert(utf8.encode(password))}',
      if (password != null) 'encrypt': 1,
      if (username != null) 'unitid': _unitId,
      if (username != null) 'unitcode': 'jmu',
      'clientinfo': jsonEncode(_loginClientInfo),
    };
  }

  Map<String, dynamic> get _loginClientInfo {
    return <String, dynamic>{
      'appid': _appId,
      if (Platform.isIOS) 'packetid': '',
      'platform': Platform.isIOS ? 40 : 30,
      'platformver': Platform.isIOS ? '2.3.2' : '2.3.1',
      'deviceid': DeviceUtil.deviceUuid,
      'devicetype': _deviceType,
      'systype': '$_deviceType OS',
      'sysver': Platform.isIOS ? '12.2' : '9.0',
    };
  }
}

/// Fow news list.
final int _appId = Platform.isIOS ? 274 : 273;
const String _apiKey = 'c2bd7a89a377595c1da3d49a0ca825d5';
const String _cloudId = 'jmu';
final String _deviceType = Platform.isIOS ? 'iPhone' : 'Android';
const int _marketTeamId = 430;
const String _unitCode = 'jmu';
const int _unitId = 55;

const String _postApiKeyAndroid = '1FD8506EF9FF0FAB7CAFEBB610F536A1';
const String _postApiKeyIOS = '3E63F9003DF7BE296A865910D8DEE630';
const String _postApiSecretAndroid = 'E3277DE3AED6E2E5711A12F707FA2365';
const String _postApiSecretIOS = '773958E5CFE0FF8252808C417A8ECCAB';
