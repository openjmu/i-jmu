///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/23 18:11
///
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:i_jmu/constants/exports.dart';

class MainPageNotifier extends ChangeNotifier {
  MainPageNotifier() {
    request();
  }

  bool _isLoading = false, _hasError = false;

  SystemConfig? _systemConfig;
  BannerConfig? _bannerConfig;
  List<ServiceModel>? _services;

  bool get isEmpty =>
      _systemConfig == null && _bannerConfig == null && _services == null;

  int get currentBanner => _currentBanner;
  int _currentBanner = 0;

  set currentBanner(int value) {
    if (value == _currentBanner) {
      return;
    }
    _currentBanner = value;
    notifyListeners();
  }

  Color get swatchColor {
    if (_bannerConfig == null) {
      return defaultLightColor;
    }
    return Color(
      int.parse(
        _bannerConfig!.marqueePics[_currentBanner].color
            .replaceAll('#', '0xff'),
      ),
    );
  }

  Future<void> request() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    try {
      await Future.wait(
        <Future<void>>[
          _fetchSystemConfig(),
          _fetchBannerConfig(),
          _fetchRecommendedServices(),
        ],
        eagerError: true,
      );
    } catch (e) {
      _hasError = true;
      showToast(e.errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchSystemConfig() async {
    final ResponseModel<SystemConfig> res = await PortalAPI.systemConfig();
    _systemConfig = res.data;
  }

  Future<void> _fetchBannerConfig() async {
    final ResponseModel<BannerConfig> res = await PortalAPI.bannerConfig();
    _bannerConfig = res.data;
  }

  Future<void> _fetchRecommendedServices() async {
    final ResponseModel<ServiceModel> res =
        await PortalAPI.servicesForceRecommended();
    _services = res.models;
  }
}

@FFRoute(name: 'jmu://main-page', routeName: '首页')
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => navigator.pushNamed(Routes.jmuSearchPage.name),
      child: Container(
        padding: const EdgeInsets.all(kToolbarHeight / 4),
        height: kToolbarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: RadiusConstants.max,
                  color: context.surfaceColor.withOpacity(.3),
                ),
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.search, color: Colors.white, size: 18),
                    Text(
                      '大家都在搜：iJMU',
                      style: TextStyle(color: Colors.white, height: 1.25),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _swatchColorBuilder(Color color) {
    return Positioned.fill(
      bottom: null,
      child: ClipPath(
        clipper: const _ArcClipper(0.75),
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          height: 250,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(_) {
    return Scaffold(
      body: ChangeNotifierProvider<MainPageNotifier>(
        create: (_) => MainPageNotifier(),
        builder: (_, __) => Consumer<MainPageNotifier>(
          builder: (BuildContext context, MainPageNotifier m, _) {
            if (m._isLoading && m.isEmpty) {
              return const Center(
                child: LoadingProgressIndicator(),
              );
            }
            if (m._hasError) {
              return const ListEmptyIndicator(isSliver: false, isError: true);
            }
            return Stack(
              children: <Widget>[
                _swatchColorBuilder(m.swatchColor),
                Positioned.fill(
                  child: SafeArea(
                    bottom: false,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(child: _searchBar(context)),
                        if (m._systemConfig != null)
                          SliverToBoxAdapter(
                            child: _QuickActionsPanel(m._systemConfig!),
                          ),
                        if (m._bannerConfig != null)
                          SliverToBoxAdapter(
                            child: _BannerPanel(m._bannerConfig!),
                          ),
                        if (m._services != null)
                          _RecommendedServicesPanel(m._services!),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArcClipper extends CustomClipper<Path> {
  const _ArcClipper(this.ratio) : assert(ratio > 0 && ratio < 1);

  final double ratio;

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * ratio)
      ..quadraticBezierTo(size.width / 2, size.height, 0, size.height * ratio)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(_ArcClipper oldClipper) => ratio != oldClipper.ratio;
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel(this._config, {Key? key}) : super(key: key);

  final SystemConfig _config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          _config.eCardSets.length,
          (int i) {
            final SystemConfigECard slot = _config.eCardSets[i];
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.network(slot.imageUrl, height: 30),
                  Text(
                    slot.name,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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

class _BannerPanel extends StatelessWidget {
  const _BannerPanel(this._config, {Key? key}) : super(key: key);

  final BannerConfig _config;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SliderView<BannerModel>(
        models: _config.marqueePics,
        imageBuilder: (BannerModel m) => m.picUrl,
        borderRadius: 10,
        onPageChanged: (int page) =>
            context.read<MainPageNotifier>().currentBanner = page,
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

class _RecommendedServicesPanel extends StatelessWidget {
  const _RecommendedServicesPanel(this._services, {Key? key}) : super(key: key);

  final List<ServiceModel> _services;

  @override
  Widget build(BuildContext context) {
    if (_services == null) {
      return const SliverToBoxAdapter(child: PlatformProgressIndicator());
    }
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final ServiceModel service = _services[index];
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
        childCount: _services.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
    );
  }
}
