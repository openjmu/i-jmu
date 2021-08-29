///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/24 14:24
///
import 'package:flutter/material.dart';
import 'package:i_jmu/exports.dart';

@FFRoute(name: 'jmu://splash-page', routeName: '闪屏页')
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      navigator.pushNamedAndRemoveUntil(
        Authenticator.hasLogin
            ? Routes.jmuMainPage.name
            : Routes.jmuLoginPage.name,
        (Route<dynamic> r) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: defaultLightColor,
      child: Center(
        child: Text(
          'iJMU',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
