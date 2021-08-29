///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 14:09
///
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:i_jmu/exports.dart';

import 'urls.dart';

class PortalAPI {
  const PortalAPI._();

  /// [keyword] - 搜索的关键字
  /// [keywordType] - 关键字类型：0 全部、1 服务
  /// [orderingRule] - 排序方式：0 默认
  /// [scope] - 暂时不详
  /// [itemsPerPage] - 分页数量
  static Future<ResponseModel<SearchResult>> search(
    String keyword, {
    int keywordType = 1,
    int orderingRule = 0,
    int scope = 1,
    int itemsPerPage = 50,
    int? startDate,
    int? endDate,
  }) {
    return HttpUtil.fetchModel(
      FetchType.get,
      url: Urls.search,
      queryParameters: <String, String>{
        'keyWord': keyword,
        'keyWordType': keywordType.toString(),
        'orderingRule': orderingRule.toString(),
        'scope': scope.toString(),
        'itemsPerPage': itemsPerPage.toString(),
        if (startDate != null) 'startDate': startDate.toString(),
        if (endDate != null) 'endDate': endDate.toString(),
      },
    );
  }

  static Future<ResponseModel<BannerConfig>> bannerConfig({
    String? type = '05',
  }) {
    return HttpUtil.fetchModel(
      FetchType.get,
      url: Urls.bannerConfig,
      queryParameters: <String, String>{
        if (type != null) 'marTypeCode': type,
      },
    );
  }

  static Future<ResponseModel<SystemConfig>> systemConfig() {
    return HttpUtil.fetchModel(
      FetchType.get,
      url: Urls.appSystemConfigurations,
    );
  }

  static Future<ResponseModel<ServiceModel>> servicesForceRecommended() {
    return HttpUtil.fetchModels(
      FetchType.get,
      url: Urls.servicesForceRecommended,
    );
  }
}

class UserAPI {
  const UserAPI._();

  static Future<ResponseModel<TokenModel>> casLogin(String u, String p) {
    return HttpUtil.fetchModel(
      FetchType.post,
      url: Urls.casLogin,
      queryParameters: <String, String>{
        'appId': PackageUtil.packageInfo.packageName,
        'clientId': md5.convert(utf8.encode(DeviceUtil.deviceUuid)).toString(),
        'deviceId': base64.encode(utf8.encode(DeviceUtil.deviceModel)),
        'username': u,
        'password': p,
      },
    );
  }

  static Future<Map<String, dynamic>> ndLogin(Map<String, dynamic> params) {
    return HttpUtil.fetch(FetchType.post, url: Urls.ndLogin, body: params);
  }

  static Future<Map<String, dynamic>> ndTicket(Map<String, dynamic> params) {
    return HttpUtil.fetch(FetchType.post, url: Urls.ndTicket, body: params);
  }
}