///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:11
///
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:i_jmu/constants/exports.dart';

@FFRoute(name: 'jmu://main-page', routeName: '首页')
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SystemConfigModel? _config;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final ResponseModel<SystemConfigModel> res = await PortalAPI.systemConfig();
    _config = res.data;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_config == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Container(
        alignment: Alignment.topCenter,
        color: defaultLightColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(
              _config!.eCardSets.length,
              (int i) {
                final SystemConfigECard slot = _config!.eCardSets[i];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(slot.imageUrl, height: 30,),
                    Text(slot.name),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
