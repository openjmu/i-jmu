///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-08-29 01:24
///
class Urls {
  const Urls._();

  static const String JMU_DOMAIN = 'jmu.edu.cn';

  static const String oa99Host = 'https://oa99.$JMU_DOMAIN';
  static const String passHost = 'paas.$JMU_DOMAIN';
  static const String tokenHost = 'https://token.$passHost';
  static const String portalServiceHost = 'https://portal-service.$passHost';

  /// Login with password.
  static const String casLogin = '$tokenHost/password/passwordLogin';
  static const String ndLogin = '$oa99Host/v2/passport/api/user/login1';
  static const String ndTicket = '$oa99Host/v2/passport/api/user/loginticket1';

  static const String appSystemConfigurations =
      '$portalServiceHost/v1/config/system/getAppSystemConf';
  static const String bannerConfig = '$portalServiceHost/v1/cms/marquee/get';

  /// Service APIs.
  static const String services = '$portalServiceHost/v1/service';
  static const String servicesForceRecommended =
      '$services/findForceRecommService';

  static const String search = '$portalServiceHost/v1/search/globalSearch';
}
