///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:35
///
import 'package:flutter/material.dart';
import 'package:i_jmu/constants/exports.dart';

@FFRoute(name: 'jmu://login-page', routeName: '登录页')
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _uTec = TextEditingController();
  final TextEditingController _pTec = TextEditingController();
  Object? response;

  @override
  void dispose() {
    _uTec.dispose();
    _pTec.dispose();
    super.dispose();
  }

  Future<void> requestLogin() async {
    final ResponseModel<TokenModel> res = await UserAPI.login(
      _uTec.text,
      _pTec.text,
    );
    response = res.data?.toString();
    if (res.isSucceed) {
      UserAPI.token = res.data!.idToken;
      navigator.pushNamedAndRemoveUntil(
        Routes.jmuMainPage.name,
        (Route<dynamic> r) => false,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录页')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You\'ve ${UserAPI.isLogon ? '' : 'not '}logon.',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
              controller: _uTec,
              decoration: const InputDecoration(hintText: 'username'),
            ),
            TextField(
              controller: _pTec,
              decoration: const InputDecoration(hintText: 'password'),
            ),
            const Text('Click the FAB to make the login request.'),
            Text(
              '$response',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: requestLogin,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
