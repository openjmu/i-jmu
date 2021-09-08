///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021-08-29 01:24
///
class Urls {
  const Urls._();

  static const String JMU_DOMAIN = 'jmu.edu.cn';
  static const String wwwHost = 'https://www.$JMU_DOMAIN';
  static const String wwwHostInsecure = 'http://www.$JMU_DOMAIN';
  static const String passHost = 'paas.$JMU_DOMAIN';
  static const String tokenHost = 'https://token.$passHost';
  static const String portalServiceHost = 'https://portal-service.$passHost';
  static const String portalUiHost = 'https://portal-ui.$passHost';
  static const String classKitHost = 'https://classkit.$JMU_DOMAIN';
  static const String oa99Host = 'https://oa99.$JMU_DOMAIN';
  static const String oap99Host = 'https://oap99.$JMU_DOMAIN';
  static const String labsHost = 'http://labs.$JMU_DOMAIN';
  static const String webVPNHost = 'https://webvpn.$JMU_DOMAIN';
  static const String webVPNHostInsecure = 'http://webvpn.$JMU_DOMAIN';
  static const String casWebVPNHost = 'https://cas-paas-443.webvpn.$JMU_DOMAIN';
  static const String jwxtHost = 'http://jwxt.$JMU_DOMAIN';

  static const String alexHost = 'https://openjmu.alexv525.com';

  static const List<String> ssoHosts = <String>[
    classKitHost,
    oa99Host,
    oap99Host,
    labsHost,
  ];

  /// Login with password.
  static const String casLogin = '$tokenHost/password/passwordLogin';
  static const String ndLogin = '$oa99Host/v2/passport/api/user/login1';
  static const String ndTicket = '$oa99Host/v2/passport/api/user/loginticket1';
  static const String ndUserInfo = '$oap99Host/user/info'; // 用户信息
  static const String webVpnLogin = '$casWebVPNHost/cas/login'
      '?service=https%3A%2F%2Fwebvpn.jmu.edu.cn'
      '%2Fusers%2Fauth%2Fcas%2Fcallback%3Furl'; // 由 CAS 登录 WebVPN

  static const String appSystemConfigurations =
      '$portalServiceHost/v1/config/system/getAppSystemConf';
  static const String bannerConfig = '$portalServiceHost/v1/cms/marquee/get';

  /// Service APIs.
  static const String services = '$portalServiceHost/v1/service';
  static const String servicesForceRecommended =
      '$services/findForceRecommService';

  static const String search = '$portalServiceHost/v1/search/globalSearch';

  static const String firstDayOfTerm = '$alexHost/api/first-day-of-term';

  static const String courses =
      '$labsHost/CourseSchedule/StudentCourseSchedule';
  static const String courseRemark =
      '$labsHost/CourseSchedule/StudentClassRemark';
  static const String coursesPage = '$jwxtHost/student/for-std/course-table';

  /// 将域名替换为 WebVPN 映射的二级域名
  ///
  /// 原地址：http://labs.jmu.edu.cn
  /// 替换后：https://labs-jmu-edu-cn.webvpn.jmu.edu.cn
  static String replaceWithWebVPN(String url) {
    assert(url.startsWith(RegExp(r'http|https')));
    final Uri uri = Uri.parse(url);
    String newHost = uri.host.replaceAll('.', '-');
    if (uri.port != 0 && uri.port != 80) {
      newHost += '-${uri.port}';
    }
    String replacedUrl = 'https://$newHost.webvpn.jmu.edu.cn';
    if (uri.path.isNotEmpty) {
      replacedUrl += uri.path;
    }
    if (uri.query.isNotEmpty) {
      replacedUrl += '?${uri.query}';
    }
    return replacedUrl;
  }
}
