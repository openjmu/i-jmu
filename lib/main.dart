import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
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
    final ThemeData theme = ThemeData(primarySwatch: defaultLightColor.swatch);
    return Theme(
      data: theme,
      child: OKToast(
        position: ToastPosition.bottom,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          navigatorKey: Instances.navigatorKey,
          onGenerateRoute: (RouteSettings settings) => onGenerateRoute(
            settings: settings,
            getRouteSettings: getRouteSettings,
          ),
          initialRoute: Routes.jmuSplashPage.name,
          builder: (BuildContext c, Widget? w) => RepaintBoundary(
            key: Instances.appRepaintBoundaryKey,
            child: DoubleBackExitWrapper(child: w!),
          ),
        ),
      ),
    );
  }
}
