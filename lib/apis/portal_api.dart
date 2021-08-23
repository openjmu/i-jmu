///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:38
///
part of 'api.dart';

class PortalAPI {
  const PortalAPI._();

  static Future<ResponseModel<SystemConfigModel>> systemConfig() {
    return HttpUtil.fetchModel(FetchType.get, url: API.appSystemConfigurations);
  }
}
