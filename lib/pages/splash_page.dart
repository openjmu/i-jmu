///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/24 14:24
///
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:i_jmu/exports.dart';

@FFRoute(name: 'jmu://splash-page', routeName: '闪屏页')
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final ValueNotifier<bool> _isTakingTooLong = ValueNotifier<bool>(false);
  late final Timer _costTimer;

  @override
  void initState() {
    super.initState();
    _costTimer = Timer(const Duration(seconds: 5), () {
      _isTakingTooLong.value = true;
    });
    _initialize();
  }

  @override
  void dispose() {
    _isTakingTooLong.dispose();
    _costTimer.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    await HttpUtil.initConfig();
    if (!mounted) {
      return;
    }
    if (Authenticator.hasLogin &&
        (await Authenticator.reAuthAll()).every((bool v) => v)) {
      navigator.pushNamedAndRemoveUntil(
        Routes.jmuMainPage.name,
        (Route<dynamic> r) => false,
      );
      return;
    }
    navigator.pushNamedAndRemoveUntil(
      Routes.jmuLoginPage.name,
      (Route<dynamic> r) => false,
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: defaultLightColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'iJMU',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          const Gap.v(50),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isTakingTooLong,
                builder: (_, bool value, __) => AnimatedCrossFade(
                  crossFadeState: value
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: kTabScrollDuration,
                  firstChild: const LoadingProgressIndicator(),
                  secondChild: const SizedBox.shrink(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
