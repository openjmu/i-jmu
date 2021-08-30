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
  late final Timer _costTimer = Timer(const Duration(seconds: 5), () {
    _isTakingTooLong.value = true;
  });

  @override
  void initState() {
    super.initState();
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
    navigator.pushNamedAndRemoveUntil(
      Authenticator.hasLogin
          ? Routes.jmuMainPage.name
          : Routes.jmuLoginPage.name,
      (Route<dynamic> r) => false,
    );
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
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isTakingTooLong,
              builder: (_, bool value, __) {
                if (value) {
                  return const LoadingProgressIndicator();
                }
                return const SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }
}
