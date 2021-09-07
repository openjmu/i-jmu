///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/31 13:49
///
import 'package:flutter/material.dart';
@FFArgumentImport()
import 'package:flutter/widgets.dart';
import 'package:i_jmu/exports.dart';

import 'home/courses_page.dart';
import 'home/main_page.dart';

@FFRoute(name: 'jmu://home-page', routeName: '首页')
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  void selectIndex(int value) {
    if (_index == value) {
      return;
    }
    safeSetState(() {
      _index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LazyIndexedStack(
        index: _index,
        children: const <Widget>[
          CoursesPage(),
          MainPage(),
        ],
      ),
    );
  }
}
