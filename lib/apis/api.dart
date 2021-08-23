///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 14:09
///
import 'package:i_jmu/constants/exports.dart';

part 'portal_api.dart';

part 'user_api.dart';

class API {
  const API._();

  static const String passHost = 'paas.jmu.edu.cn';
  static const String tokenHost = 'https://token.$passHost';
  static const String portalServiceHost = 'https://portal-service.$passHost';

  /// Login with password.
  static const String login = '$tokenHost/password/passwordLogin';

  static const String appSystemConfigurations =
      '$portalServiceHost/v1/config/system/getAppSystemConf';
}
