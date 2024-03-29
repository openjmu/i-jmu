///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 1/11/21 7:15 PM
///
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart' show Response;
import 'package:android_scheme_search/android_scheme_search.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../authenticators/authenticator.dart';
import '../constants/constants.dart';
import '../constants/styles.dart';
import '../extensions/build_context_extension.dart';
import '../extensions/state_extension.dart';
import '../internal/screens.dart';
import '../internal/urls.dart';
import '../internal/user.dart';
import '../utils/http_util.dart';
import '../utils/log_util.dart';
import '../utils/other_utils.dart';
import '../utils/package_util.dart';
import '../utils/toast_util.dart';
import 'dialogs/base_dialog.dart';
import 'fixed_appbar.dart';
import 'gaps.dart';
import 'loading/loading_progress_indicator.dart';

@FFRoute(name: 'jmu://web-view', routeName: '网页浏览')
class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({
    Key? key,
    required this.url,
    this.title = '网页链接',
    this.withCookie = true,
    this.withAction = true,
    this.withNavigationControls = false,
    this.withScaffold = true,
    this.keepAlive = false,
  }) : super(key: key);

  final String url;
  final String? title;
  final bool withCookie;
  final bool withAction;
  final bool withNavigationControls;
  final bool withScaffold;
  final bool keepAlive;

  static void launch({
    required BuildContext context,
    required String url,
    String? title,
    bool withCookie = true,
    bool withAction = true,
    bool withScaffold = true,
    bool withNavigationControls = false,
    bool keepAlive = false,
  }) {
    Navigator.of(context).pushNamed(
      'jmu://web-view',
      arguments: <String, dynamic>{
        'url': url,
        'title': title,
        'withCookie': withCookie,
        'withAction': withAction,
        'withNavigationControls': withNavigationControls,
        'withScaffold': withScaffold,
        'keepAlive': keepAlive,
      },
    );
  }

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  late InAppWebView _webView;
  InAppWebViewController? _webViewController;

  late String url = widget.url.trim();

  String get urlDomain => Uri.parse(url).host;
  late final ValueNotifier<String?> title =
      ValueNotifier<String?>(widget.title?.trim() ?? '网页链接');

  bool _handlingCourses = false;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    _webView = newWebView;
  }

  @override
  void didUpdateWidget(InAppWebViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.withCookie != widget.withCookie ||
        oldWidget.withAction != widget.withAction ||
        oldWidget.withNavigationControls != widget.withNavigationControls ||
        oldWidget.withScaffold != widget.withScaffold ||
        oldWidget.keepAlive != widget.keepAlive) {
      safeSetState(() {
        _webView = newWebView;
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _webView = newWebView;
  }

  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    _isLoading.dispose();
    super.dispose();
  }

  /// 检查 scheme 是否可以拉起 App (Android Only) - `shouldOverrideUrlLoading`
  bool checkSchemeLoad(InAppWebViewController controller, String url) {
    // TODO(Alex): iOS 上 url 返回全小写，需要进一步确认。
    final Uri _uri = Uri.parse(url);
    if (_uri.scheme != 'http' && _uri.scheme != 'https') {
      LogUtil.d('Found scheme when load: $url');
      if (Platform.isAndroid) {
        Future<void>.delayed(const Duration(microseconds: 1), () async {
          controller.stopLoading();
          LogUtil.d('Try to launch intent...');
          final String? appName = await AndroidSchemeSearchPlugin.search(url);
          if (appName != null) {
            final bool shouldLaunch = await _waitForSchemeLaunch(appName);
            if (shouldLaunch) {
              await _launchURL(url: url);
            }
          }
        });
      }
      return true;
    }
    return false;
  }

  /// 确认是否跳转外部应用
  Future<bool> _waitForSchemeLaunch(String applicationLabel) {
    return BaseDialog.show(
      context: context,
      title: '跳转外部应用',
      description: '即将打开应用\n$applicationLabel',
      confirmLabel: '允许',
    );
  }

  /// 尝试通过系统浏览器打开 url
  Future<void> _launchURL({String? url, bool forceSafariVC = true}) async {
    final String uri = Uri.encodeFull(url ?? this.url);
    if (await canLaunch(uri)) {
      await launch(uri, forceSafariVC: Platform.isIOS && forceSafariVC);
    } else {
      showCenterErrorToast('无法打开网址: $uri');
    }
  }

  Future<void> onDownload(InAppWebViewController controller, Uri url) async {
    final String _url = url.toString();
    final Response<dynamic> res = await HttpUtil.getResponse<dynamic>(
      FetchType.head,
      url: _url,
    );
    final String filename = await HttpUtil.getFilenameFromResponse(res, _url);
    if (await BaseDialog.show(
      context: context,
      title: '文件下载确认',
      description: '文件安全性未知，请确认下载\n\n'
          '${url.host}\n想要下载文件'
          '\n$filename',
      showConfirm: true,
      confirmLabel: '下载',
    )) {
      LogUtil.d('WebView started download from: $url');
      HttpUtil.download(url.toString(), filename);
    }
  }

  Widget _domainProvider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '网页由 $urlDomain 提供',
        style: context.textTheme.caption!.copyWith(fontSize: 12),
      ),
    );
  }

  Widget _moreAction({
    required BuildContext context,
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6).copyWith(left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: onTap != null
                ? () {
                    Navigator.of(context).pop();
                    onTap();
                  }
                : null,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.theme.canvasColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Icon(icon, size: 30)),
            ),
          ),
          const Gap.v(10),
          Text(
            text,
            style: context.textTheme.caption!.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// 右上角显示更多
  void showMore(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: context.theme.cardColor,
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 32,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: RadiusConstants.max,
              color: context.theme.iconTheme.color!.withOpacity(0.7),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                _moreAction(
                  context: context,
                  icon: Icons.content_copy,
                  text: '复制链接',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: url));
                    showToast('已复制网址到剪贴板');
                  },
                ),
                _moreAction(
                  context: context,
                  icon: Icons.open_in_browser,
                  text: '浏览器打开',
                  onTap: () => _launchURL(forceSafariVC: false),
                ),
              ],
            ),
          ),
          _domainProvider(context),
          Gap.v(Screens.bottomSafeHeight),
        ],
      ),
    );
  }

  Future<void> _handleCourseInject(InAppWebViewController controller) async {
    if (_handlingCourses) {
      return;
    }
    _handlingCourses = true;
    final int currentSemesterId = await controller.evaluateJavascript(
      source: 'currentSemester["id"]',
    ) as int;
    final int studentId = await controller.evaluateJavascript(
      source: 'studentId[0]',
    ) as int;
    LogUtil.d('$currentSemesterId $studentId');
    final CallAsyncJavaScriptResult? r = await controller.callAsyncJavaScript(
      functionBody: '''
var p = new Promise(function (resolve, reject) {
  \$.get("course-table/semester/$currentSemesterId/print-data/$studentId")
  .done(function(data) {
    resolve(data);
  })
  .fail(function() {
    reject(null);
  })
});
await p;
return p;
''',
    );
    if (r?.value is Map) {
      showToast('课表拦截成功');
      LogUtil.d(r);
    }
    _handlingCourses = false;
  }

  FixedAppBar get appBar {
    return FixedAppBar(
      title: ValueListenableBuilder<String?>(
        valueListenable: title,
        builder: (_, String? value, __) => Text(
          value!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
      actions: <Widget>[
        if (widget.withAction) _actionBar(context),
      ],
    );
  }

  Widget _actionBar(BuildContext context) {
    Widget _action(IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(icon, size: 20),
        ),
      );
    }

    return Container(
      margin: const EdgeInsetsDirectional.only(end: 8),
      decoration: BoxDecoration(
        borderRadius: RadiusConstants.max,
        color: context.theme.textTheme.bodyText2?.color?.withOpacity(.1),
      ),
      child: Row(
        children: <Widget>[
          _action(Icons.more_horiz_outlined, () => showMore(context)),
          Gap.v(
            30,
            width: 1,
            color: context.theme.canvasColor,
          ),
          _action(Icons.adjust_outlined, () => context.navigator.pop()),
        ],
      ),
    );
  }

  Widget get _footerControls {
    const double _iconSize = 28;
    return Padding(
      padding: EdgeInsets.only(bottom: context.bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: defaultLightColor,
              size: _iconSize,
            ),
            onPressed: () => _webViewController?.goBack(),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.keyboard_arrow_right,
              color: defaultLightColor,
              size: _iconSize,
            ),
            onPressed: () => _webViewController?.goForward(),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.refresh),
            color: defaultLightColor,
            // 刷新图标较大，需要缩小
            iconSize: _iconSize / 1.25,
            onPressed: () => _webViewController?.reload(),
          ),
        ],
      ),
    );
  }

  Widget _loadingIndicator(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (BuildContext context, bool value, _) => AnimatedCrossFade(
        duration: kTabScrollDuration,
        firstChild: const Center(child: LoadingProgressIndicator()),
        secondChild: const SizedBox.expand(),
        crossFadeState:
            value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        layoutBuilder: (Widget tw, Key tk, Widget bw, Key bk) {
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(key: bk, child: bw),
              Positioned(key: tk, child: tw),
            ],
          );
        },
      ),
    );
  }

  InAppWebView get newWebView {
    return InAppWebView(
      key: Key(currentTimeStamp.toString()),
      initialUrlRequest: URLRequest(
        url: Uri.parse(url),
        headers: <String, String>{
          if (CASAuthenticator().logonPredicate()) 'userToken': User.casToken!,
          if (CASAuthenticator().logonPredicate()) 'X-Id-Token': User.casToken!,
          'X-Requested-With': PackageUtil.packageInfo.packageName,
        },
      ),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          allowFileAccessFromFileURLs: true,
          allowUniversalAccessFromFileURLs: true,
          applicationNameForUserAgent: 'iJMU-client',
          cacheEnabled: widget.withCookie,
          clearCache: !widget.withCookie,
          horizontalScrollBarEnabled: false,
          javaScriptCanOpenWindowsAutomatically: false,
          preferredContentMode: UserPreferredContentMode.MOBILE,
          supportZoom: true,
          transparentBackground: true,
          useOnDownloadStart: true,
          useShouldOverrideUrlLoading: true,
          verticalScrollBarEnabled: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          builtInZoomControls: true,
          displayZoomControls: false,
          mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          safeBrowsingEnabled: false,
          supportMultipleWindows: false,
          forceDark: AndroidForceDark.FORCE_DARK_AUTO,
        ),
        ios: IOSInAppWebViewOptions(
          allowsAirPlayForMediaPlayback: true,
          allowsBackForwardNavigationGestures: true,
          allowsInlineMediaPlayback: true,
          allowsLinkPreview: true,
          allowsPictureInPictureMediaPlayback: true,
          isFraudulentWebsiteWarningEnabled: false,
        ),
      ),
      onCreateWindow: (
        InAppWebViewController controller,
        CreateWindowAction createWindowAction,
      ) async {
        if (createWindowAction.request.url != null) {
          await controller.loadUrl(urlRequest: createWindowAction.request);
          return true;
        }
        return false;
      },
      onLoadStart: (_, Uri? url) {
        LogUtil.d('WebView onLoadStart: $url');
        _isLoading.value = true;
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        LogUtil.d('WebView onLoadStop: $url');
        _isLoading.value = false;
        controller.evaluateJavascript(
          source: 'window.onbeforeunload=null',
        );

        this.url = url.toString();
        final String? _title = (await controller.getTitle())?.trim();
        if (_title?.isNotEmpty == true && _title != this.url) {
          title.value = _title;
        } else {
          final String? ogTitle = await controller.evaluateJavascript(
            source:
                'var ogTitle = document.querySelector(\'[property="og:title"]\');\n'
                'if (ogTitle != undefined) ogTitle.content;',
          ) as String?;
          if (ogTitle != null) {
            title.value = ogTitle;
          }
        }
        if (url.toString() == Urls.coursesPage) {
          _handleCourseInject(controller);
        }
      },
      onConsoleMessage: (_, ConsoleMessage consoleMessage) {
        LogUtil.d(
          'Console message: '
          '${consoleMessage.messageLevel.toString()}'
          ' - '
          '${consoleMessage.message}',
        );
      },
      onDownloadStart: onDownload,
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
      },
      shouldOverrideUrlLoading: (
        InAppWebViewController controller,
        NavigationAction navigationAction,
      ) async {
        if (checkSchemeLoad(
          controller,
          navigationAction.request.url!.toString(),
        )) {
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
      androidOnGeolocationPermissionsShowPrompt:
          (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(
          allow: await checkPermissions(<Permission>[Permission.location]),
          origin: origin,
        );
      },
    );
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController?.canGoBack() == true) {
          _webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: FixedAppBarScaffold(
        appBar: appBar,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _webView),
                  _loadingIndicator(context),
                ],
              ),
            ),
            if (widget.withNavigationControls) _footerControls,
          ],
        ),
      ),
    );
  }
}
