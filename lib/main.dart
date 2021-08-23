import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
    <Future<void>>[
      (() async {
        await Hive.initFlutter();
        await Boxes.openBoxes();
      })(),
      DeviceUtil.initDeviceInfo(),
      PackageUtil.initInfo(),
    ],
    eagerError: true,
  );
  UserAPI.recoverToken();
  runApp(const IJMUApp());
}

class IJMUApp extends StatelessWidget {
  const IJMUApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: Instances.navigatorKey,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (BuildContext c, Widget? w) {
        return RepaintBoundary(key: Instances.appRepaintBoundaryKey, child: w);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    if (res.isSucceed) {
      response = res.data?.toString();
      UserAPI.token = res.data!.idToken;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You\'ve ${UserAPI.isLogon ? '' : 'not '}logon.',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text('Click the FAB to make the request.'),
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
