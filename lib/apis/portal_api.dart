///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:38
///
part of 'api.dart';

class PortalAPI {
  const PortalAPI._();

  static Future<ResponseModel<BannerConfig>> bannerConfig({
    String? type = '05',
  }) {
    return HttpUtil.fetchModel(
      FetchType.get,
      url: API.bannerConfig,
      queryParameters: <String, String>{
        if (type != null) 'marTypeCode': type,
      },
    );
  }

  static Future<ResponseModel<SystemConfig>> systemConfig() {
    return HttpUtil.fetchModel(FetchType.get, url: API.appSystemConfigurations);
  }

  static Future<ResponseModel<ServiceModel>> servicesForceRecommended() {
    return HttpUtil.fetchModels(
      FetchType.get,
      url: API.servicesForceRecommended,
    );
  }
}
