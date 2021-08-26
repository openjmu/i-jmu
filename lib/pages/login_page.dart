///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:35
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:i_jmu/constants/exports.dart';

class LoginNotifier extends BaseChangeNotifier {
  String get username => _username;
  String _username = '';

  set username(String value) {
    if (value == _username) {
      return;
    }
    _username = value;
  }

  bool get canClearUsername => _username.isNotEmpty;

  String get password => _password;
  String _password = '';

  set password(String value) {
    if (value == _password) {
      return;
    }
    _password = value;
  }

  bool get checkedAgreement => _checkedAgreement;
  bool _checkedAgreement = false;

  set checkedAgreement(bool value) {
    if (value == _checkedAgreement) {
      return;
    }
    _checkedAgreement = value;
    notifyListeners();
  }

  bool get isLoginButtonEnabled =>
      _username.isNotEmpty && _password.isNotEmpty && _checkedAgreement;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  set isLoading(bool value) {
    if (value == _isLoading) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }

  bool get isObscure => _isObscure;
  bool _isObscure = true;

  set isObscure(bool value) {
    if (value == _isObscure) {
      return;
    }
    _isObscure = value;
    notifyListeners();
  }

  bool get isPreview => _isPreview;
  bool _isPreview = true;

  set isPreview(bool value) {
    if (value == _isPreview) {
      return;
    }
    _isPreview = value;
    notifyListeners();
  }

  bool get isKeyboardAppeared => _isKeyboardAppeared;
  bool _isKeyboardAppeared = false;

  set isKeyboardAppeared(bool value) {
    if (value == _isKeyboardAppeared) {
      return;
    }
    _isKeyboardAppeared = value;
    notifyListeners();
  }
}

@FFRoute(name: 'jmu://login', routeName: '登录页')
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with RouteAware {
  final LoginNotifier notifier = LoginNotifier();

  /// Common animate duration.
  /// 通用的动画周期
  Duration get animateDuration => kRadialReactionDuration;

  /// TEC for fields.
  /// 字段的输入控制器
  final TextEditingController _uTec = TextEditingController();
  final TextEditingController _pTec = TextEditingController();

  /// 背景视频的控制器
  final VideoPlayerController videoController = VideoPlayerController.asset(
    R.ASSETS_LOGIN_BACKGROUND_VIDEO_MP4,
  );

  @override
  void initState() {
    super.initState();
    // Bind text fields listener.
    // 绑定输入部件的监听
    _uTec.addListener(usernameListener);
    _pTec.addListener(passwordListener);

    initializeVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Instances.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // Dispose all controllers.
    // 销毁所有控制器
    _uTec.dispose();
    _pTec.dispose();
    videoController
      ..setLooping(false)
      ..pause()
      ..dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    videoController.play();
  }

  @override
  void didPushNext() {
    // 跳转至其他页面时，取消输入框聚焦
    dismissFocusNodes();
    videoController.pause();
  }

  /// Listener for username text field.
  /// 账户输入字段的监听
  void usernameListener() {
    notifier.username = _uTec.text;
  }

  /// Listener for password text field.
  /// 密码输入字段的监听
  void passwordListener() {
    notifier.password = _pTec.text;
  }

  /// 初始化视频控制器及配置
  Future<void> initializeVideo() async {
    await Future.wait(<Future<void>>[
      videoController.setLooping(true),
      videoController.setVolume(0.0),
      videoController.initialize(),
    ]);
    videoController.play();
  }

  /// Function called after login button pressed.
  /// 登录按钮的回调
  Future<void> loginButtonPressed(BuildContext context) async {
    if (notifier.isLoading) {
      return;
    }
    try {
      notifier.isLoading = true;
      final ResponseModel<TokenModel> res = await UserAPI.login(
        _uTec.text,
        _pTec.text,
      );
      if (res.isSucceed) {
        UserAPI.token = res.data!.idToken;
        await videoController.setLooping(false);
        await videoController.pause();
        navigator.pushNamedAndRemoveUntil(
          Routes.jmuMainPage.name,
          (Route<dynamic> r) => false,
        );
      }
    } catch (e) {
      LogUtil.e('Failed when login: $e');
      showErrorToast('登录失败 (-1 ${e.errorMessage})');
    } finally {
      notifier.isLoading = false;
    }
  }

  /// Function called after search username pressed.
  /// 查询工号按钮的回调
  Future<void> searchUsername() async {
    BaseDialog.show(context: context, title: '暂不支持');
  }

  /// Function called after forgot button pressed.
  /// 忘记密码按钮的回调
  Future<void> forgotPassword() async {
    BaseDialog.show(context: context, title: '暂不支持');
  }

  /// Set input fields alignment to avoid blocked by insets
  /// when the input methods was shown/hidden.
  /// 键盘弹出或收起时设置输入字段的对齐方式以防止遮挡。
  void setAlignment(BuildContext context) {
    final double inputMethodHeight = MediaQuery.of(context).viewInsets.bottom;
    if (inputMethodHeight > 1) {
      notifier.isKeyboardAppeared = true;
    } else if (inputMethodHeight <= 1) {
      notifier.isKeyboardAppeared = false;
    }
  }

  /// Function called when triggered listener.
  /// 触发页面监听器时，所有的输入框失焦，隐藏键盘。
  void dismissFocusNodes() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Video player for the background video.
  /// 背景视频播放器
  Widget videoWidget(BuildContext context) {
    return Positioned.fill(child: VideoPlayer(videoController));
  }

  /// Filter for the video player.
  /// 视频播放的滤镜
  Widget videoFilter(BuildContext context) {
    return Positioned.fill(
      child: Selector<LoginNotifier, bool>(
        selector: (_, LoginNotifier p) => p.isPreview,
        builder: (_, bool value, __) => AnimatedContainer(
          duration: animateDuration * 5,
          color: value ? Colors.black45 : context.theme.colorScheme.surface,
        ),
      ),
    );
  }

  /// Welcome tip widget.
  /// 欢迎语部件
  Widget get welcomeTip {
    return Selector<LoginNotifier, bool>(
      selector: (_, LoginNotifier p) => p.isPreview,
      builder: (_, bool value, __) => Container(
        margin: const EdgeInsets.symmetric(vertical: 18),
        child: Text(
          '欢迎使用',
          style: TextStyle(
            color: value ? Colors.white : null,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Username field.
  /// 账户输入部件
  Widget get usernameField {
    return _InputFieldWrapper(
      title: '学号/工号/手机号/证件号',
      controller: _uTec,
      keyboardType: TextInputType.number,
      suffixWidget: Selector<LoginNotifier, bool>(
        selector: (_, LoginNotifier p) => p.canClearUsername,
        builder: (_, bool value, __) {
          if (!value) {
            return const SizedBox.shrink();
          }
          return GestureDetector(
            onTap: _uTec.clear,
            child: SvgPicture.asset(
              R.ASSETS_ICONS_CLEAR_INPUT_SVG,
              width: 36,
              color: context.iconTheme.color,
            ),
          );
        },
      ),
    );
  }

  /// Password field.
  /// 密码输入部件
  Widget get passwordField {
    return Selector<LoginNotifier, bool>(
      selector: (_, LoginNotifier p) => p.isObscure,
      builder: (_, bool isObscure, __) => _InputFieldWrapper(
        title: '密码',
        controller: _pTec,
        obscureText: isObscure,
        suffixWidget: GestureDetector(
          onTap: () {
            notifier.isObscure = !isObscure;
          },
          child: SvgPicture.asset(
            isObscure
                ? R.ASSETS_ICONS_NOT_OBSCURE_SVG
                : R.ASSETS_ICONS_OBSCURE_SVG,
            width: 36,
            color: isObscure ? context.iconTheme.color : defaultLightColor,
          ),
        ),
      ),
    );
  }

  /// Agreement checkbox.
  /// 用户协议复选框
  Widget get agreementCheckbox {
    return SizedBox.fromSize(
      size: const Size.square(28),
      child: Consumer<LoginNotifier>(
        builder: (_, LoginNotifier p, __) => GestureDetector(
          onTap: () {
            if (p.isLoading) {
              return;
            }
            p.checkedAgreement = !p.checkedAgreement;
          },
          child: SvgPicture.asset(
            p.checkedAgreement
                ? R.ASSETS_ICONS_AGREEMENT_AGREED_SVG
                : R.ASSETS_ICONS_AGREEMENT_SVG,
            color: context.textTheme.bodyText2?.color,
          ),
        ),
      ),
    );
  }

  /// Agreement tips.
  /// 用户协议提示
  Widget get agreementTip {
    return Selector<LoginNotifier, bool>(
      selector: (_, LoginNotifier p) => p.isPreview,
      builder: (_, bool value, __) => Text.rich(
        TextSpan(
          children: const <TextSpan>[
            TextSpan(text: '登录即代表您同意'),
            TextSpan(
              text: '《用户协议》',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ],
          style: TextStyle(
            color: value ? Colors.white : null,
            fontSize: 18,
          ),
        ),
        maxLines: 1,
        overflow: TextOverflow.fade,
      ),
    );
  }

  /// Agreement widget.
  /// 用户协议部件。包含复选框和提示。
  Widget get agreementWidget {
    return Selector<LoginNotifier, bool>(
      selector: (_, LoginNotifier p) => p.isPreview,
      builder: (_, bool value, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!value) agreementCheckbox,
            if (!value) const Gap.h(16),
            agreementTip,
          ],
        ),
      ),
    );
  }

  /// Wrapper for content part.
  /// 内容块包装
  Widget contentWrapper(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (_, LoginNotifier p, __) => GestureDetector(
        onTap: dismissFocusNodes,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  welcomeTip,
                  const Spacer(),
                  if (!p.isPreview)
                    Expanded(
                      flex: 30,
                      child: AnimatedAlign(
                        duration: animateDuration,
                        curve: Curves.easeInOut,
                        alignment: p.isKeyboardAppeared
                            ? Alignment.topCenter
                            : Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            usernameField,
                            passwordField,
                            agreementWidget,
                          ],
                        ),
                      ),
                    ),
                  if (!p.isPreview) const Spacer(flex: 8),
                  if (p.isPreview) agreementWidget,
                  if (!p.isPreview)
                    DefaultTextStyle.merge(
                      style: context.textTheme.bodyText2?.copyWith(
                        fontSize: 17,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: GestureDetector(
                                onTap: searchUsername,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Text('学工号查询'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: context.textTheme.bodyText2?.color,
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: GestureDetector(
                                onTap: forgotPassword,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Text('忘记密码'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Gap.v(100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Login button.
  /// 登录按钮
  Widget loginButton(BuildContext context) {
    return Consumer<LoginNotifier>(
        builder: (_, LoginNotifier p, __) => Positioned.fill(
              top: null,
              bottom: Screens.bottomSafeHeight,
              child: GestureDetector(
                onTap: () {
                  if (p.isPreview) {
                    p.isPreview = false;
                    Future<void>.delayed(animateDuration * 5, () {
                      videoController.pause();
                    });
                  }
                  if (p.isLoginButtonEnabled) {
                    loginButtonPressed(context);
                  }
                },
                child: AnimatedContainer(
                  duration: animateDuration,
                  height: 72,
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: p.isPreview || p.isLoginButtonEnabled
                        ? defaultLightColor
                        : Colors.black54,
                  ),
                ),
              ),
            ),
        child: Center(
          child: Selector<LoginNotifier, bool>(
            selector: (_, LoginNotifier p) => p.isLoading,
            builder: (_, bool isLoading, __) {
              Widget _child;
              if (isLoading) {
                _child = const LoadingProgressIndicator();
              } else {
                _child = const Text(
                  '登录',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return AnimatedSwitcher(duration: animateDuration, child: _child);
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    setAlignment(context);
    return Selector<LoginNotifier, bool>(
      selector: (_, LoginNotifier p) => p.isPreview,
      builder: (BuildContext context, bool isPreview, Widget? w) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: isPreview || context.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: w!,
      ),
      child: WillPopScope(
        onWillPop: doubleBackExit,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 18),
            child: Stack(
              children: <Widget>[
                videoWidget(context),
                videoFilter(context),
                contentWrapper(context),
                loginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Input field wrapper.
/// 输入区域包装
///
/// [title] 标签文字, [child] 内容部件
class _InputFieldWrapper extends StatelessWidget {
  const _InputFieldWrapper({
    Key? key,
    required this.title,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixWidget,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            color: context.theme.canvasColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Selector<LoginNotifier, bool>(
                        selector: (_, LoginNotifier p) => p.isLoading,
                        builder: (_, bool disabled, __) => TextField(
                          controller: controller,
                          keyboardType: keyboardType,
                          enabled: !disabled,
                          obscureText: obscureText,
                          obscuringCharacter: '*',
                          scrollPadding: EdgeInsets.zero,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: context.textTheme.bodyText2?.copyWith(
                            height: 1.26,
                            fontSize: 36,
                          ),
                        ),
                      ),
                    ),
                    if (suffixWidget != null) suffixWidget!,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
