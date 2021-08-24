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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: defaultLightColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _QuickActionsPanel()),
          SliverToBoxAdapter(child: _BannerPanel()),
          _RecommendedServicesPanel(),
        ],
      ),
    );
  }
}

class _QuickActionsPanel extends StatefulWidget {
  const _QuickActionsPanel({Key? key}) : super(key: key);

  @override
  _QuickActionsPanelState createState() => _QuickActionsPanelState();
}

class _QuickActionsPanelState extends State<_QuickActionsPanel> {
  SystemConfig? _config;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final ResponseModel<SystemConfig> res = await PortalAPI.systemConfig();
    _config = res.data;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_config == null) {
      return const PlatformProgressIndicator();
    }
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          _config!.eCardSets.length,
          (int i) {
            final SystemConfigECard slot = _config!.eCardSets[i];
            return GestureDetector(
              onTap: () {
                if (slot.composedUrl != null) {
                  navigator.pushNamed(
                    Routes.jmuWebView.name,
                    arguments: Routes.jmuWebView.d(url: slot.composedUrl!),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(slot.imageUrl, height: 30),
                  Text(
                    slot.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BannerPanel extends StatefulWidget {
  const _BannerPanel({Key? key}) : super(key: key);

  @override
  _BannerPanelState createState() => _BannerPanelState();
}

class _BannerPanelState extends State<_BannerPanel> {
  BannerConfig? _config;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final ResponseModel<BannerConfig> res = await PortalAPI.bannerConfig();
    _config = res.data;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_config == null) {
      return const PlatformProgressIndicator();
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SliderView<BannerModel>(
        models: _config!.marqueePics,
        imageBuilder: (BannerModel m) => m.picUrl,
        borderRadius: 10,
        onItemTap: (int index, BannerModel m) {
          if (m.url != null) {
            navigator.pushNamed(
              Routes.jmuWebView.name,
              arguments: Routes.jmuWebView.d(
                url: m.url!,
                title: m.title,
              ),
            );
          }
        },
      ),
    );
  }
}

class _RecommendedServicesPanel extends StatefulWidget {
  const _RecommendedServicesPanel({Key? key}) : super(key: key);

  @override
  _RecommendedServicesPanelState createState() =>
      _RecommendedServicesPanelState();
}

class _RecommendedServicesPanelState extends State<_RecommendedServicesPanel> {
  List<ServiceModel>? _services;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final ResponseModel<ServiceModel> res =
        await PortalAPI.servicesForceRecommended();
    _services = res.models;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_services == null) {
      return const SliverToBoxAdapter(child: PlatformProgressIndicator());
    }
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final ServiceModel service = _services![index];
          return GestureDetector(
            onTap: () {
              navigator.pushNamed(
                Routes.jmuWebView.name,
                arguments: Routes.jmuWebView.d(url: service.serviceUrl),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.network(service.iconUrl, width: 50),
                Text(service.serviceName),
              ],
            ),
          );
        },
        childCount: _services!.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
    );
  }
}
