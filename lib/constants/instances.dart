///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 15:34
///
import 'package:flutter/material.dart';

NavigatorState get navigatorState => Instances.navigatorKey.currentState!;

BuildContext get overlayContext => navigatorState.overlay!.context;

class Instances {
  const Instances._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final RouteObserver<Route<dynamic>> routeObserver =
      RouteObserver<Route<dynamic>>();
  static AppLifecycleState appLifeCycleState = AppLifecycleState.resumed;

  static GlobalKey appRepaintBoundaryKey = GlobalKey();
}
