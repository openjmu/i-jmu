///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/31 14:24
///
part of 'authenticator.dart';

class VPNAuthenticator extends Authenticator {
  @override
  // bool logonPredicate() => false;
  bool logonPredicate() =>
      Boxes.containerBox.get(BoxFields.nU) is String &&
      Boxes.containerBox.get(BoxFields.nP) is String;

  @override
  Future<bool> login(String u, String p) async {
    // 先判断是否已登录，如果正常则无需继续后续流程。
    if (await _isWebVpnLogin()) {
      return true;
    }

    // 访问门户，得到 Session。
    await HttpUtil.dio.get<dynamic>(
      Urls.webVpnLogin,
      options: Options(maxRedirects: 30),
    );
    try {
      // 构造登录请求。
      await HttpUtil.dio.post<dynamic>(
        Urls.webVpnLogin,
        data: <String, dynamic>{
          'username': u,
          'password': p,
          'execution': 'e1s1',
          '_eventId': 'submit',
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: <String, dynamic>{
            'origin': Urls.casWebVPNHost,
            'referer': Urls.webVpnLogin,
          },
          // followRedirects: false, // 禁止重定向，拦截 Set-Cookies。
          followRedirects: true,
          maxRedirects: 30,
        ),
      );
      return true;
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.response &&
          dioError.response?.statusCode == HttpStatus.found) {
        final Response<dynamic> _r = dioError.response!;
        final String location = _r.headers.value('location')!;
        final List<String> _casCookies = _r.headers['set-cookie']!;
        if (location == null || _casCookies == null) {
          return false;
        }
        // 重定向后，为 CAS 设置 TGC Cookie，并且获得 WebVPN 登录的 ticket。
        await _setCookies(<String>[Urls.casWebVPNHost], _casCookies);
        try {
          await HttpUtil.dio.get<dynamic>(
            location,
            options: Options(followRedirects: false),
          );
          return false;
        } on DioError catch (dioError) {
          if (dioError.type == DioErrorType.response &&
              dioError.response?.statusCode == HttpStatus.found) {
            final Response<dynamic> _r = dioError.response!;
            final String location = _r.headers.value('location')!;
            final List<String> _ticketCookies = _r.headers['set-cookie']!;
            if (location == null || _ticketCookies == null) {
              return false;
            }
            // 重定向后，为 WebVPN 设置 _astraeus_session Cookie。
            await _setCookies(<String>[Urls.webVPNHost], _ticketCookies);
            try {
              await HttpUtil.dio.get<dynamic>(
                location,
                options: Options(followRedirects: false),
              );
              return false;
            } on DioError catch (dioError) {
              if (dioError.type == DioErrorType.response &&
                  dioError.response?.statusCode == HttpStatus.found) {
                final Response<dynamic> _r = dioError.response!;
                final String location = _r.headers.value('location')!;
                final List<String> setCookies = _r.headers['set-cookie']!;
                if (location == null || setCookies == null) {
                  return false;
                }
                // 最终为全站设置所有的身份。
                await _setHostsCookies(
                  <String>[..._casCookies, ..._ticketCookies, ...setCookies],
                );
                return true;
              }
              return false;
            } catch (e) {
              return false;
            }
          }
          return false;
        } catch (e) {
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> reAuth([bool logoutWhenFailed = true]) => login(
        Boxes.containerBox.get(BoxFields.nU) as String,
        Boxes.containerBox.get(BoxFields.nP) as String,
      );

  Future<void> _setCookies(List<String> urls, List<String> cookies) async {
    final List<Cookie> _cookies =
        cookies.map((String e) => Cookie.fromSetCookieValue(e)).toList();
    await HttpUtil.updateDomainsCookies(urls, _cookies);
  }

  Future<bool> _isWebVpnLogin() async {
    try {
      await HttpUtil.dio.get<void>(
        Urls.webVpnLogin,
        options: Options(followRedirects: false),
      );
      return false;
    } on DioError catch (dioError) {
      if (dioError.response?.statusCode == HttpStatus.found) {
        if (dioError.response!.headers
                .value('location')
                ?.startsWith('https://webvpn-jmu-edu-cn-s') ==
            true) {
          return true;
        }
        LogUtil.d('WebVPN redirects to the sign in page...');
        return false;
      }
      return false;
    } catch (e) {
      LogUtil.d('Error when checking WebVPN login status: $e');
      return false;
    }
  }

  Future<void> _setHostsCookies(List<String> values) async {
    final List<Cookie> cookies =
        values.map((String e) => Cookie.fromSetCookieValue(e)).toList();
    await Future.wait(<Future<void>>[
      HttpUtil.updateDomainsCookies(
        <String>[
          Urls.wwwHost,
          Urls.wwwHostInsecure,
          Urls.webVPNHost,
          Urls.webVPNHostInsecure,
        ],
        cookies,
      ),
      for (final Cookie cookie in cookies)
        HttpUtil.webViewCookieManager.setCookie(
          url: Uri.parse(Urls.wwwHost),
          name: cookie.name,
          value: cookie.value,
          domain: 'webvpn.jmu.edu.cn',
          path: cookie.path ?? '/',
          isSecure: false,
          sameSite: HTTPCookieSameSitePolicy.LAX,
        ),
      for (final Cookie cookie in cookies)
        HttpUtil.webViewCookieManager.setCookie(
          url: Uri.parse(Urls.wwwHostInsecure),
          name: cookie.name,
          value: cookie.value,
          domain: 'webvpn.jmu.edu.cn',
          path: cookie.path ?? '/',
          isSecure: false,
          sameSite: HTTPCookieSameSitePolicy.LAX,
        ),
      for (final Cookie cookie in cookies)
        HttpUtil.webViewCookieManager.setCookie(
          url: Uri.parse(Urls.webVPNHostInsecure),
          name: cookie.name,
          value: cookie.value,
          domain: 'webvpn.jmu.edu.cn',
          path: cookie.path ?? '/',
          isSecure: false,
          sameSite: HTTPCookieSameSitePolicy.LAX,
        ),
      for (final Cookie cookie in cookies)
        HttpUtil.webViewCookieManager.setCookie(
          url: Uri.parse(Urls.webVPNHost),
          name: cookie.name,
          value: cookie.value,
          domain: 'webvpn.jmu.edu.cn',
          path: cookie.path ?? '/',
          isSecure: false,
          sameSite: HTTPCookieSameSitePolicy.LAX,
        ),
    ]);
  }
}
