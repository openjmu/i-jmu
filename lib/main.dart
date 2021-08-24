import 'package:flutter/material.dart';
import 'constants/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Boxes.openBoxes();
  await Future.wait(
    <Future<void>>[
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
      theme: ThemeData(primarySwatch: defaultLightColor.swatch),
      navigatorKey: Instances.navigatorKey,
      onGenerateRoute: (RouteSettings settings) => onGenerateRoute(
        settings: settings,
        getRouteSettings: getRouteSettings,
      ),
      initialRoute: Routes.jmuMainPage.name,
      builder: (BuildContext c, Widget? w) => RepaintBoundary(
        key: Instances.appRepaintBoundaryKey,
        child: w,
      ),
    );
  }
}
